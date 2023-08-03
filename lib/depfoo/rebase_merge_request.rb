# frozen_string_literal: true
module Depfoo
  class RebaseMergeRequest
    def initialize(token:, gitlab_url:, merge_request_id:)
      @token = token
      @gitlab_url = gitlab_url
      @merge_request_id = merge_request_id
    end

    def call
      Faraday.put("#{@gitlab_url}/#{@merge_request_id}/rebase",
                  { base_sha: master_sha }.to_json, { 'Content-Type' => 'application/json', 'PRIVATE-TOKEN' => @token })
    end

    private

    def master_sha
      response = Faraday.get(repository_url,
                             {}, { 'Content-Type' => 'application/json', 'PRIVATE-TOKEN' => @token })

      JSON.parse(response.body)['commit']['id']
    end

    def repository_url
      parts = @gitlab_url.split('/')
      parts[-1] = 'repository'
      parts << 'branches'
      parts << 'master'
      parts.join('/')
    end
  end
end
