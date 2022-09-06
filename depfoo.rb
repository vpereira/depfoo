# frozen_string_literal: true


require_relative './lib/depfoo'

timestamp = Time.now.to_i

# name of the gem
gem_name = ARGV[1]

# patch, minor, major
working_mode = ARGV[0]
# default working mode = patch
working_mode = 'patch' if working_mode.nil?

depfoo_config = Depfoo::Config.new(Depfoo::PrepareConfig.new.call)

FileUtils.cd(File.join(FileUtils.getwd, depfoo_config.config['PROJECT_SOURCE_CODE']))
g = Git.open(File.join(FileUtils.getwd), log: Logger.new($stdout))
g.checkout(depfoo_config.config['TARGET_BRANCH'])
# we should at least pass gem and/or working_mode
Depfoo::OutdatedGems.new.call.each do |gem|
  # TODO: deal with empty line in the OutdatedGems
  next if gem.nil?
  gem_name = gem[:name]
  gpre = Depfoo::GitlabCheckMergeRequest.new(token: depfoo_config.private_token, gem: gem[:name],
                                             gitlab_url: depfoo_config.gitlab_full_url, working_mode: working_mode)
  next if gpre.pr_exist?

  source_branch = "update_#{gem_name}_#{working_mode}_#{timestamp}"
  pr_title = "WIP: Dependencies update #{gem_name} #{working_mode} #{timestamp}"

  g.branch(source_branch).checkout
  `bundle update #{gem_name} --#{working_mode} --strict`
  g.commit_all("DEPFOO: Update #{gem_name} from #{gem[:old_version]} to #{gem[:new_version]}")
  # TODO
  # - push source branch to origin
  # - generate the PR description
  # - create PR
  #
  # puts source_branch, pr_title


  # reset back to master
  g.checkout(depfoo_config.config['TARGET_BRANCH'])
end
