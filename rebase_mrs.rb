# frozen_string_literal: true

require_relative './lib/depfoo'

depfoo_config = Depfoo::Config.new(Depfoo::PrepareConfig.new.call)

Depfoo::GitlabRebaseMergeRequests.new(token: depfoo_config.private_token, gitlab_url: depfoo_config.gitlab_full_url).call
