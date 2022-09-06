# frozen_string_literal: true

require_relative './spec_helper'

describe Config do
  let(:config_hash) do
    { 'PRIVATE_TOKEN' => '0xdeadbeef',
      'GITLAB_PROJECT_ID' => '31337',
      'GITLAB_URL' => 'https://example.org/v4/projects/' }
  end

  describe '.new' do
    let(:config) { Config.new(config_hash) }

    it { config }
  end

  describe '#gitlab_full_url' do
    let(:config) { Config.new(config_hash) }

    it { _(config.gitlab_full_url).must_equal('https://example.org/v4/projects/31337/merge_requests') }
  end
end
