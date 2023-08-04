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

        match_data = x.match(/^(.+) \(newest (.+), installed (.+)\)/i).captures
        { name: match_data[0], new_version: match_data[1], old_version: match_data[2] }
      end.compact
    end

    private

    def bundle_command_line
      `bundle outdated --parseable --#{@working_mode} #{@gem}`
    end
  end
end
