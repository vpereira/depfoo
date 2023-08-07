# frozen_string_literal: true

require 'json'
require 'yaml'
require 'erb'
require 'bundler'
require 'faraday'
require 'git'
require 'pry'
require 'fileutils'
require 'dotenv'

require_relative './depfoo/version'
require_relative './depfoo/config/prepare_config'
require_relative './depfoo/config/config'
require_relative './depfoo/config/read_ignore_list'
require_relative './depfoo/bundle/outdated_gems'
require_relative './depfoo/open_merge_request'
require_relative './depfoo/gitlab_merge_request'
require_relative './depfoo/gitlab_rebase_merge_requests'
require_relative './depfoo/rebase_merge_request'
require_relative './depfoo/merge_request_diff'
require_relative './depfoo/close_merge_request_without_changes'
require_relative './depfoo/gitlab/check_merge_request'
require_relative './depfoo/gitlab/close_merge_request'
require_relative './depfoo/content/merge_request_description'
require_relative './depfoo/content/gitlab_pull_request_body'
require_relative './depfoo/content/gitlab_pull_request_metadata'

module Depfoo; end
