# frozen_string_literal: true

module Depfoo
  class GitlabCloseMergeRequest
    def initialize(token:, gitlab_url:, merge_request_id:)
      @token = token
      @gitlab_url = gitlab_url
      @merge_request_id = merge_request_id
    end

    def call
      Faraday.put(mr_url, { state_event: 'close' }.to_json,
                  { 'Content-Type' => 'application/json', 'PRIVATE-TOKEN' => @token })
    end

    def mr_url
      "#{@gitlab_url}/#{@merge_request_id}"
    end
  end
end
