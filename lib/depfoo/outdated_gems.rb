# frozen_string_literal: true

module Depfoo
  class OutdatedGems
    def initialize(working_mode: 'patch', gem: nil)
      @working_mode = working_mode
      @gem = gem
      @check_all = @gem.nil?
    end

    def call
      bundle_command_line.split("\n").collect do |x|
        next if x.empty?

        x.match(/^(.+) \(newest (.+), installed (.+)\)/i).captures
        { name: ::Regexp.last_match(1), new_version: ::Regexp.last_match(2), old_version: ::Regexp.last_match(3) }
      end
    end

    private

    def bundle_command_line
      `bundle outdated --parseable --#{@working_mode} #{@gem}`
    end
  end
end
