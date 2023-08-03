# frozen_string_literal: true

require_relative './lib/depfoo'

depfoo_config = Depfoo::Config.new(Depfoo::PrepareConfig.new.call)

Depfoo::GitlabMergeRequest.new(token: depfoo_config.private_token, gitlab_url: depfoo_config.gitlab_full_url).empty_mrs.each do |mr_id|
  Depfoo::GitlabCloseMergeRequest.new(token: depfoo_config.private_token,
                                      gitlab_url: depfoo_config.gitlab_full_url, merge_request_id: mr_id).call
end
