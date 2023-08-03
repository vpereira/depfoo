# frozen_string_literal: true

require_relative './lib/depfoo'

depfoo_config = Depfoo::Config.new(Depfoo::PrepareConfig.new.call)

Depfoo::GitlabMergeRequest.new(token: depfoo_config.private_token, gitlab_url: depfoo_config.gitlab_full_url).open_mrs.each do |mr|
  Depfoo::RebaseMergeRequest.new(token: depfoo_config.private_token, gitlab_url: depfoo_config.gitlab_full_url, merge_request_id: mr['id']).call
end
