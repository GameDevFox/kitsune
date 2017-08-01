require 'spec_helper'

RSpec.describe Kitsune::Hash do
  it 'should generate sha256 hash' do
    hash = Kitsune::Hash.sha256 'test'
    expect(hash.to_hex).to eql '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08'
  end

  it 'should generate index hash' do
    hash = Kitsune::Hash.index_hash 0
    expect(hash.to_hex).to eql '9ebc7e7e37a262eed9f50eb0e20675db43fd6fa2426d7f7d5653d54549048414'

    hash = Kitsune::Hash.index_hash 3
    expect(hash.to_hex).to eql '073d9984348ce41b5683247b6f2b238e13f03c02b1db00814685f5aed33d7b59'

    hash = Kitsune::Hash.index_hash 10
    expect(hash.to_hex).to eql 'd203186ffc1fc9c3e8e302604dae0d07294ebb6c00c5a97fa01b1ad3017fc8e1'
  end

  it 'should generate compound hash' do
    hash = Kitsune::Hash.compound_hash ['hello', 'world', 'one', 'more']
    expect(hash.to_hex).to eql '5a9069d7e98fcddb06d133877a11b0f5344f6b5a978ed138a1f4b9cd740456b4'
  end

  it 'should generate shake256 chain hash' do
    hash = Kitsune::Hash.chain_hash 'test'
    expect(hash.to_hex).to eql '1f9c0fa205f9209718d1047d060d3cac3a45578bbe3fca1de61ecb88d0f623f4'
  end

  it 'should generate shake256 chain hash of specified size' do
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
