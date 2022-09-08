# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/minitest'
require 'fileutils'
require 'pry'

require 'simplecov'
require 'simplecov-lcov'
SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
SimpleCov.start

require_relative '../lib/depfoo'

include Depfoo
