# frozen_string_literal: true

require_relative './lib/depfoo'

timestamp = Time.now.to_i

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
  next if ignore_list.include?(gem_name)

  gpre = Depfoo::GitlabCheckMergeRequest.new(token: depfoo_config.private_token, gem: gem[:name],
                                             gitlab_url: depfoo_config.gitlab_full_url, working_mode: working_mode)
  next if gpre.pr_exist?

  source_branch = "update_#{gem_name}_#{working_mode}_#{timestamp}"
  pr_title = "WIP: Dependencies update #{gem_name} #{working_mode} #{timestamp}"

  git.branch(source_branch).checkout

  # try to update the gem
  `bundle update #{gem_name} --#{working_mode} --strict`

  next if git.status.changed.empty?

  git.commit_all("DEPFOO: Update #{gem_name} from #{gem[:old_version]} to #{gem[:new_version]}")

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
