# frozen_string_literal: true

require 'faraday'
module Depfoo
  class GitlabCheckMergeRequest
    def initialize(token:, gitlab_url:, gem:, working_mode: 'patch')
      @token = token
      @gitlab_url = gitlab_url
      @gem = gem
      @working_mode = working_mode
    end

    def pr_exist?
      get_all_open_prs_json.collect do |m|
        m.select do |k, v|
          k == 'source_branch' && v =~ /update_#{@gem}_#{@working_mode}/
        end
      end.reject(&:empty?).any?
    end

    private

    def get_all_open_prs_json
      JSON.parse get_all_prs.body
    end

    def get_all_prs
      Faraday.get(@gitlab_url, { state: 'opened' },
                  { 'Content-Type' => 'application/json', 'PRIVATE-TOKEN' => @token })
    end
  end
end
