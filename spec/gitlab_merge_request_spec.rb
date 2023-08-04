# frozen_string_literal: true

require_relative './spec_helper'

module OpenMrsJsonPayload
  def self.body
    File.read(File.join(__dir__, 'fixtures', 'open_mrs.json')) # Assuming you have open_mrs.json as fixture
  end
end

module EmptyMergeRequestDiff
  def self.body
    File.read(File.join(__dir__, 'fixtures', 'empty_diff.json')) # Assuming you have open_mrs.json as fixture
  end
end

describe Depfoo::GitlabMergeRequest do
  let(:gmr) do
    Depfoo::GitlabMergeRequest.new(token: 'foo', gitlab_url: 'https://example.org')
  end

  before do
    gmr.stubs(:open_mrs).returns(JSON.parse(OpenMrsJsonPayload.body))
    Depfoo::MergeRequestDiff.any_instance.stubs(:call).returns(JSON.parse(EmptyMergeRequestDiff.body))
  end

  describe '#empty_mrs' do
    it 'returns the expected output' do
      expected_output = [1] # the id of the MR
      _(gmr.empty_mrs).must_equal expected_output
    end
  end

  describe '#open_mrs' do
    it 'returns the parsed JSON data' do
      _(gmr.open_mrs).must_equal JSON.parse(OpenMrsJsonPayload.body)
    end
  end
end
