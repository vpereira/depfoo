# frozen_string_literal: true

require 'dotenv'

module Depfoo
  class PrepareConfig
    CONFIG_KEYS = %w[TARGET_BRANCH GITLAB_USER_ID GITLAB_PROJECT_ID GITLAB_URL PRIVATE_TOKEN PROJECT_SOURCE_CODE
                     LABEL].freeze

    def parse_env_file(env_path = nil)
      if env_path
        Dotenv.load(env_path)
      else
        Dotenv.load
      end
    end

    def call(env_path = nil)
      parse_env_file(env_path)
      ENV.slice(*CONFIG_KEYS)
    end
  end
end
