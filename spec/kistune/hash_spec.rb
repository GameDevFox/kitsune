require 'spec_helper'

RSpec.describe Kitsune::Hash do
  it 'can get sha256 hash' do
    hash = Kitsune::Hash.sha256_hash 'test'
    expect(hash.to_hex).to eql '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08'
  end

  it 'can get shake256 chain hash' do
    hash = Kitsune::Hash.chain_hash 'test'
    expect(hash.to_hex).to eql '1f9c0fa205f9209718d1047d060d3cac3a45578bbe3fca1de61ecb88d0f623f4'
  end

  it 'can get shake256 chain hash of specified size' do
    hash = Kitsune::Hash.chain_hash 'test', size: 64
    expect(hash.to_hex).to eql(
      '1f9c0fa205f9209718d1047d060d3cac3a45578bbe3fca1de61ecb88d0f623f4' +
      '12fe8a4059b94b1f4da1f03326bc8d2970d81963f9a67b9f005e64d3f7ae3b3c'
    )
  end

  it 'can get shake256 chain hash at specified index' do
    hash = Kitsune::Hash.chain_hash 'test', index: 5
    expect(hash.to_hex).to eql '29bf879b1903338be2e58ebc8c118ae214bb2adc7f9aee5be4f83a1bf7bc3ef6'
  end
end
