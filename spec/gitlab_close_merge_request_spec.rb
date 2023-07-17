# frozen_string_literal: true

require_relative './spec_helper'

describe GitlabCloseMergeRequest do
  let(:gcmr) { GitlabCloseMergeRequest.new(token: 'foo', merge_request_id: 11, gitlab_url: 'https://gitlab.example.org/projects/31337') }

  it { _(gcmr.mr_url).must_equal 'https://gitlab.example.org/projects/31337/merge_requests/11' }
end
