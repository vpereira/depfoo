# frozen_string_literal: true

require 'faraday'
module Depfoo
  class GitlabCloseMergeRequest
    def initialize(token:, gitlab_url:, mr:)
      @token = token
      @gitlab_url = gitlab_url
      @mr = mr
    end

    def close
      Faraday.put(mr_url, { state_event: 'close' },
                  { 'Content-Type' => 'application/json', 'PRIVATE-TOKEN' => @token })
    end

    def mr_url
      "#{@gitlab_url}/merge_requests/#{@mr}"
    end
  end
end
