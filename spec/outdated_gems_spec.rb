# frozen_string_literal: true

require_relative './spec_helper'

describe OutdatedGems do
  let(:outdated_gems) { OutdatedGems.new }
  let(:bundle_outdated_output) { File.read(File.join(__dir__, 'fixtures', 'bundle_outdated.txt')) }
  let(:outdated_gems_call) { outdated_gems.call }

  before do
    outdated_gems.stubs(:bundle_command_line).returns(bundle_outdated_output)
  end

  it { _(outdated_gems.call.first).must_be_instance_of(Hash) }
  it { _(outdated_gems.call.first.keys.to_set).must_equal %i[name new_version old_version].to_set }
end
