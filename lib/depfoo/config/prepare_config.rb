# frozen_string_literal: true

require 'dotenv'

module Depfoo
  class PrepareConfig
    CONFIG_KEYS = %w[TARGET_BRANCH GITLAB_USER_ID GITLAB_PROJECT_ID GITLAB_URL PRIVATE_TOKEN PROJECT_SOURCE_CODE LABEL].freeze

    def parse_env_file
      Dotenv.load
    end

    def call
      parse_env_file
      ENV.slice(*CONFIG_KEYS)
    end
  end
end
