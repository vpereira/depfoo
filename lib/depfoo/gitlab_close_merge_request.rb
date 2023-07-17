# frozen_string_literal: true

require 'faraday'
module Depfoo
  class GitlabCloseMergeRequest
    def initialize(token:, gitlab_url:, merge_request_id:)
      @token = token
      @gitlab_url = gitlab_url
      @merge_request_id = merge_request_id
    end

    def call
      res = Faraday.put(mr_url, { state_event: 'close' }.to_json,
                  { 'Content-Type' => 'application/json', 'PRIVATE-TOKEN' => @token })
      if res.success?
        puts "Merge request #{@merge_request_id} closed"
      else
        puts "Merge request #{@merge_request_id} not closed"
        puts res.body
      end
      res
    end

    def mr_url
      "#{@gitlab_url}/merge_requests/#{@merge_request_id}"
    end
  end
end
