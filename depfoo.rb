# frozen_string_literal: true

require 'optparse'
require_relative './lib/depfoo'

def update_gems(working_mode, depfoo_config)
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
end

def rebase_mrs(depfoo_config)
  Depfoo::GitlabRebaseMergeRequests.new(token: depfoo_config.private_token,
                                        gitlab_url: depfoo_config.gitlab_full_url).call
end

def close_empty_mrs(depfoo_config)
  Depfoo::GitlabMergeRequest.new(token: depfoo_config.private_token,
                                 gitlab_url: depfoo_config.gitlab_full_url).empty_mrs.each do |mr_id|
    Depfoo::GitlabCloseMergeRequest.new(token: depfoo_config.private_token,
                                        gitlab_url: depfoo_config.gitlab_full_url, merge_request_id: mr_id).call
  end
end

options = {
  env_file: nil,
  working_mode: 'patch'
}

main_options = OptionParser.new do |opts|
  opts.banner = 'Usage: depfoo [subcommand] [options]'
  opts.on('-e', '--env FILE', 'Path to .env file') do |file|
    options[:env_file] = file
  end
  opts.on('-h', '--help', 'Displays this help') do
    puts opts
    exit
  end
end

subcommands = {
  'update_gems' => OptionParser.new do |opts|
    opts.banner = 'Usage: depfoo update_gems [options]'
    opts.on('-m', '--mode MODE', 'Working mode for update_gems (patch, minor, major)') do |mode|
      options[:working_mode] = mode
    end
  end,
  'rebase_mrs' => OptionParser.new do |opts|
    opts.banner = 'Usage: depfoo rebase_mrs'
  end,
  'close_empty_mrs' => OptionParser.new do |opts|
    opts.banner = 'Usage: depfoo close_empty_mrs'
  end
}

subcommand = ARGV.shift
subcommand_opts = subcommands[subcommand]

if subcommand_opts.nil?
  puts main_options
else
  main_options.order!(ARGV)
  subcommand_opts.parse!(ARGV)
  depfoo_config = Depfoo::Config.new(Depfoo::PrepareConfig.new.call(options[:env_file]))

  case subcommand
  when 'update_gems'
    update_gems(options.fetch(:working_mode, 'patch'), depfoo_config) # default to 'patch' if not specified
  when 'rebase_mrs'
    rebase_mrs(depfoo_config)
  when 'close_empty_mrs'
    close_empty_mrs(depfoo_config)
  else
    puts main_options
  end
end
