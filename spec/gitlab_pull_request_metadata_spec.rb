# frozen_string_literal: true

require_relative './spec_helper'

describe GitlabPullRequestMetadata do
  let(:gem_params) do
    {
      name: 'foo',
      old_version: '1.1.1',
      new_version: '1.1.2'
    }
  end
  let(:gprb) { GitlabPullRequestMetadata.new(gem_params: gem_params) }

  describe '#body' do
    it { _(gprb.source_branch).wont_be_nil }
    it { _(gprb.pr_title).wont_be_nil }
    it { _(gprb.commit_message).wont_be_nil }
    it { _(gprb.pr_title).must_be_instance_of(String) }
    it { _(gprb.source_branch).must_be_instance_of(String) }
  end
end
