# frozen_string_literal: true

module Depfoo
  class MergeRequestDiff
    def initialize(token:, gitlab_url:, merge_request_id:)
      @token = token
      @gitlab_url = gitlab_url
      @merge_request_id = merge_request_id
    end

    def call
      JSON.parse(Faraday.get("#{@gitlab_url}/#{@merge_request_id}/diffs",
                             { labels: label_name, diff_head: true }, { 'Content-Type' => 'application/json', 'PRIVATE-TOKEN' => @token }).body)
    end

    def label_name
      'depfoo'
    end
  end
end
