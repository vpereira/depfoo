# frozen_string_literal: true

module Depfoo
  class GitlabPullRequestBody
    def initialize(description:, source_branch:, title:, config: {})
      @config = config
      @description = description
      @source_branch = source_branch
      @title = title
    end

    def body
      {
        id: @config['GITLAB_PROJECT_ID'],
        source_branch: @source_branch,
        target_branch: @config['TARGET_BRANCH'],
        remove_source_branch: true,
        title: @title,
        assignee_id: @config['GITLAB_USER_ID'],
        description: @description,
        labels: ['depfoo']
      }.to_json
    end
  end
end
