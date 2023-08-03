# frozen_string_literal: true

module Depfoo
  class GitlabCheckMergeRequest
    def initialize(token:, gitlab_url:, gem:, working_mode: 'patch')
      @token = token
      @gitlab_url = gitlab_url
      @gem = gem
      @working_mode = working_mode
    end

    # it check if a specific PR exist for a gem and working mode
    # i.e update_rails_patch or update_rails_minor
    def pr_exist?
      related_open_mrs(check_working_mode: true).reject(&:empty?).any?
    end

    alias mr_exist? pr_exist?

    # it check if a PR exist for a gem, regardless of the working mode
    def pr_to_gem_exist?
      related_open_mrs(check_working_mode: false).reject(&:empty?).any?
    end

    alias mr_to_gem_exist? pr_to_gem_exist?

    def related_open_prs(check_working_mode: false)
      get_all_open_mrs_json.select do |m|
        m.any? { |k, v| k == 'source_branch' && v =~ /#{regex_for_mr(check_working_mode: check_working_mode)}/ }
      end
    end

    alias related_open_mrs related_open_prs

    private

    def regex_for_pr(check_working_mode: false)
      check_working_mode ? "update_#{@gem}_#{@working_mode}" : "update_#{@gem}_.+"
    end

    alias regex_for_mr regex_for_pr

    def get_all_open_prs_json
      JSON.parse get_all_prs.body
    end

    alias get_all_open_mrs_json get_all_open_prs_json

    def get_all_prs
      Faraday.get(@gitlab_url, { state: 'opened' },
                  { 'Content-Type' => 'application/json', 'PRIVATE-TOKEN' => @token })
    end

    alias get_all_mrs get_all_prs
  end
end
