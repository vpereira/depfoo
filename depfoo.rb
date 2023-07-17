# frozen_string_literal: true

require_relative './lib/depfoo'

# patch, minor, major
working_mode = ARGV[0]

# default working mode = patch
working_mode = 'patch' if working_mode.nil?

depfoo_config = Depfoo::Config.new(Depfoo::PrepareConfig.new.call)
ignore_list = Depfoo::ReadIgnoreList.new.call

FileUtils.cd(File.join(FileUtils.getwd, depfoo_config.config['PROJECT_SOURCE_CODE']))

git = Git.open(File.join(FileUtils.getwd), log: Logger.new($stdout))
git.checkout(depfoo_config.config['TARGET_BRANCH'])

Depfoo::OutdatedGems.new(working_mode: working_mode).call.each do |gem|
  # TODO: deal with empty line in the OutdatedGems
  next if gem.nil?

  gem_name = gem[:name]

  # if gem is ignored, just move one
  # TODO: maybe reject it in the outer loop, i.e:
  # Depfoo::OutdatedGems.new(working_mode: working_mode).call.reject_if {... }.each do |gem|
  next if ignore_list.include?(gem_name)

  gpre = Depfoo::GitlabCheckMergeRequest.new(token: depfoo_config.private_token, gem: gem[:name],
                                             gitlab_url: depfoo_config.gitlab_full_url, working_mode: working_mode)
  # close related PRs
  if gpre.pr_to_gem_exist?
    gpre.related_open_prs(check_working_mode: false).each do |pr|
      puts "DEPFOO: Closing merge request #{pr['iid']}"
      Depfoo::GitlabCloseMergeRequest.new(gitlab_url: depfoo_config.gitlab_full_url, token: depfoo_config.private_token,
                                          merge_request_id: pr['iid']).call
    end
  end

  gitlab_pr_metadata = Depfoo::GitlabPullRequestMetadata.new(gem_params: gem, working_mode: working_mode)

  source_branch = gitlab_pr_metadata.source_branch
  pr_title = gitlab_pr_metadata.pr_title

  git.branch(source_branch).checkout

  # try to update the gem
  `bundle update #{gem_name} --#{working_mode} --strict`

  next if git.status.changed.empty?

  git.commit_all(gitlab_pr_metadata.commit_message)

  git.push('origin', source_branch)

  merge_request_description = Depfoo::MergeRequestDescription.new(gem: gem[:name], old_version: gem[:old_version],
                                                                  new_version: gem[:new_version]).render

  merge_request_body = Depfoo::GitlabPullRequestBody.new(description: merge_request_description,
                                                         source_branch: source_branch, title: pr_title, config: depfoo_config.config).body

  Depfoo::OpenMergeRequest.new(gitlab_url: depfoo_config.gitlab_full_url, token: depfoo_config.private_token,
                               data: merge_request_body).call

  # reset back to master
  git.checkout(depfoo_config.config['TARGET_BRANCH'])
end
