# frozen_string_literal: true

require_relative './spec_helper'

module JsonPayload
  def self.body
    File.read(File.join(__dir__, 'fixtures', 'merge_requests.json'))
  end
end

describe GitlabCheckMergeRequest do
  describe '#pr_exist?' do
    let(:gcmr) do
      GitlabCheckMergeRequest.new(token: 'foo', gem: 'rails', working_mode: 'patch', gitlab_url: 'https://example.org')
    end

    before do
      gcmr.stubs(:get_all_prs).returns(JsonPayload)
    end

    it { _(gcmr.pr_exist?).must_equal true }
  end

  describe '#pr_to_gem_exist?' do
    let(:gcmr) do
      GitlabCheckMergeRequest.new(token: 'foo', gem: 'rails', working_mode: 'minor', gitlab_url: 'https://example.org')
    end

    before do
      gcmr.stubs(:get_all_prs).returns(JsonPayload)
    end

    it { _(gcmr.pr_exist?).must_equal false }
    it { _(gcmr.pr_to_gem_exist?).must_equal true }
  end
end
