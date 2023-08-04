# frozen_string_literal: true

module Depfoo
  class GitlabRebaseMergeRequests
    def initialize(token:, gitlab_url:)
      @token = token
      @gitlab_url = gitlab_url
    end

    def call
      open_requests.each do |mr|
        RebaseMergeRequest.new(token: @token, gitlab_url: @gitlab_url, merge_request_id: mr['iid']).call
      end
    end

    private

    def open_requests
      GitlabMergeRequest.new(token: @token, gitlab_url: @gitlab_url).open_mrs
    end
  end
end
