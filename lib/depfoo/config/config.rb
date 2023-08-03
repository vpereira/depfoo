# frozen_string_literal: true

module Depfoo
  class Config
    attr_reader :config

    def initialize(config = {})
      @config = config
    end

    def gitlab_full_url
      File.join(@config['GITLAB_URL'], @config['GITLAB_PROJECT_ID'], 'merge_requests')
    end

    def private_token
      @config['PRIVATE_TOKEN']
    end
  end
end
