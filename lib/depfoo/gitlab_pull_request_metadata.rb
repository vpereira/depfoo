# frozen_string_literal: true

module Depfoo
  class GitlabPullRequestMetadata
    attr_accessor :working_mode

    def initialize(gem_params:, working_mode: 'patch')
      @gem_params = gem_params
      @working_mode = working_mode
      @timestamp = Time.now.to_i
    end

    def source_branch
      "update_#{gem_name}_#{@working_mode}_#{@timestamp}"
    end

    def pr_title
      "Draft: Dependencies #{@working_mode} update from version #{from_version} to version #{to_version}"
    end

    def commit_message
      "DEPFOO: Update #{gem_name} from #{from_version} to #{to_version}"
    end

    def gem_name
      @gem_params[:name]
    end

    def from_version
      @gem_params[:old_version]
    end

    def to_version
      @gem_params[:new_version]
    end
  end
end
