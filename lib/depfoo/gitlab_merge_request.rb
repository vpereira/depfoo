# frozen_string_literal: true

module Depfoo
  class GitlabMergeRequest
    def initialize(token:, gitlab_url:, label_name: 'depfoo')
      @token = token
      @gitlab_url = gitlab_url
      @label_name = label_name
    end

    # Probably you must rebase the MRs with master
    def empty_mrs
      open_mrs.map do |mr|
        mr['iid'] if Depfoo::MergeRequestDiff.new(token: @token, gitlab_url: @gitlab_url, merge_request_id: mr['iid']).call.empty?
      end.compact
    end

    def open_mrs
      JSON.parse(Faraday.get(@gitlab_url, { state: 'opened', labels: @label_name },
                             { 'Content-Type' => 'application/json', 'PRIVATE-TOKEN' => @token }).body)
    end
  end
end
