# frozen_string_literal: true

module Depfoo
  class ReadIgnoreList
    IGNORE_LIST_FILE = '.ignore_list.yml'
    attr_accessor :ignored_gems

    def initialize(ignore_file: nil)
      @ignore_file = ignore_file.nil? ? IGNORE_LIST_FILE : ignore_file
      @ignored_gems = []
    end

    def call
      File.exist?(@ignore_file) ? parse_ignored_gems : []
    end

    private

    def parse_ignored_gems
      @ignored_gems = YAML.load_file(@ignore_file).fetch('ignored_gems', []).uniq
    end
  end
end
