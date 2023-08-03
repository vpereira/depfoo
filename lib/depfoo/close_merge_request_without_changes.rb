# frozen_string_literal: true

module Depfoo
  class GitlabCloseMergeRequestWithoutChanges
    def initialize(token:, gitlab_url:)
      @token = token
      @gitlab_url = gitlab_url
    end

    def call
      MergeRequest.empty_mrs do |mr_id|
        CloseMergeRequest.new(token: @token, gitlab_url: @gitlab_url, merge_request_id: mr_id).call
      end
    end
  end
end
