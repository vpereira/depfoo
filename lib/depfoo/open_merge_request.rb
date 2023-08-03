# frozen_string_literal: true

module Depfoo
  class OpenMergeRequest
    def initialize(gitlab_url:, token:, data:)
      @gitlab_url = gitlab_url
      @token = token
      @data = data
    end

    def call
      Faraday.post(@gitlab_url, { state: 'opened' },
                   { 'Content-Type' => 'application/json', 'PRIVATE-TOKEN' => @token }) do |req|
        req.body = @data
      end
    end
  end
end
