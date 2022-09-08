# frozen_string_literal: true

require_relative './spec_helper'

describe ReadIgnoreList do
  describe '.IGNORE_LIST_FILE' do
    it { _(ReadIgnoreList::IGNORE_LIST_FILE).wont_be_nil }
  end

  describe '#call' do
    let(:ri) { ReadIgnoreList.new(ignore_file: File.join(__dir__, 'ignore_list.yml')) }

    it { _(ri.call).wont_be_nil }
  end
end
