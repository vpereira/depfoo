# frozen_string_literal: true

require_relative './spec_helper'

describe PrepareConfig do
  describe '.CONFIG_KEYS' do
    it { _(PrepareConfig::CONFIG_KEYS).wont_be_nil }
  end

  describe '#parse_env_file' do
    let(:pc) { PrepareConfig.new }
    before do
      FileUtils.cp('spec/env.example', 'spec/.env')
    end

    after do
      FileUtils.rm_f('spec/.env')
    end

    it { pc.parse_env_file }
  end
end
