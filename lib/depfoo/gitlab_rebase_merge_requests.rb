# frozen_string_literal: true

module Depfoo
  class GitlabRebaseMergeRequests
    def initialize(token:, gitlab_url:)
      @token = token
      @gitlab_url = gitlab_url
    end

    def call
      GitlabMergeRequest.new(token: token, gitlab_url: gitlab_url).open_mrs do |mr_id|
        RebaseMergeRequest.new(token: @token, gitlab_url: @gitlab_url, merge_request_id: mr_id).call
      end
    end
  end
end
