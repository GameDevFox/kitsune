require 'kitsune/spec_helper'

using Kitsune::Refine

RSpec.describe Kitsune::Hash do
  it 'should generate sha256 hash' do
    hash = Kitsune::Hash.sha256 'test'
    expect(hash.to_hex).to eql('9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08')
  end

  it 'should generate get the hash for a list of hashes' do
    list = %w(hello world one more).map { |str| str.to_hex }
    hash = Kitsune::Hash.hash_list list
    expect(hash).to eql('2a6498ec4ab4a0123cc592ab1c4e4efc1aef85e4eda86d91fca35adc8b582e74')
  end
end
