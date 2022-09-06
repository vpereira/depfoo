# frozen_string_literal: true

require 'json'
require 'erb'
require 'bundler'
require 'faraday'
require 'git'
require 'pry'
require 'fileutils'
require 'dotenv'

require_relative './depfoo/version'
require_relative './depfoo/prepare_config'
require_relative './depfoo/config'
require_relative './depfoo/outdated_gems'
require_relative './depfoo/merge_request_description'
require_relative './depfoo/open_merge_request'
require_relative './depfoo/gitlab_check_merge_request'
require_relative './depfoo/gitlab_pull_request_body'

module Depfoo; end
