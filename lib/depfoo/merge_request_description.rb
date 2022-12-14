# frozen_string_literal: true

module Depfoo
  # TODO: Either move it to PullRequestDescription or rename all
  # the other classes to MergeRequestSomething
  class MergeRequestDescription
    include ERB::Util

    def initialize(gem:, old_version:, new_version:)
      @gem = gem
      @old_version = old_version
      @new_version = new_version
    end

    def template
      <<~HEREDOC
        This merge request updates <%= @gem %> from version <%= @old_version%> to <%= @new_version %>

        More information about this update can be found:

        <%= rubygems_url %>

        <%= diffend_url %>
      HEREDOC
    end

    def render
      ERB.new(template).result(binding)
    end

    private

    def rubygems_url
      File.join('https://rubygems.org/gems', @gem, 'versions', @new_version)
    end

    def diffend_url
      File.join('https://my.diffend.io/gems', @gem, @old_version, @new_version)
    end
  end
end
