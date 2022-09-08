# frozen_string_literal: true

require_relative './spec_helper'

describe GitlabPullRequestBody do
  let(:config) do
    { 'GITLAB_PROJECT_ID' => 1,
      'TARGET_BRANCH' => 'master',
      'GITLAB_USER_ID' => 1 }
  end
  let(:gprb) { GitlabPullRequestBody.new(source_branch: 'foo_bar', description: 'foo', config: config, title: 'bar') }

  describe '#body' do
    it { _(gprb.body).wont_be_nil }
    it { _(gprb.body).must_be_instance_of(String) }
    it { JSON.parse(gprb.body) }
  end
end
