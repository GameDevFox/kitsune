require 'spec_helper'

RSpec.describe Kitsune::Hash do
  it 'should generate sha256 hash' do
    hash = Kitsune::Hash.sha256 'test'
    expect(hash.to_hex).to eql('9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08')
  end

  it 'should generate index hash' do
    hash = Kitsune::Hash.index_hash 0
    expect(hash.to_hex).to eql('9ebc7e7e37a262eed9f50eb0e20675db43fd6fa2426d7f7d5653d54549048414')

    hash = Kitsune::Hash.index_hash 3
    expect(hash.to_hex).to eql('073d9984348ce41b5683247b6f2b238e13f03c02b1db00814685f5aed33d7b59')

    hash = Kitsune::Hash.index_hash 10
    expect(hash.to_hex).to eql('d203186ffc1fc9c3e8e302604dae0d07294ebb6c00c5a97fa01b1ad3017fc8e1')
  end

  it 'should generate get the hash for a list of hashes' do
    hash = Kitsune::Hash.list_hash %w(hello world one more)
    expect(hash.to_hex).to eql('2a6498ec4ab4a0123cc592ab1c4e4efc1aef85e4eda86d91fca35adc8b582e74')
  end

  it 'should generate the first hash in the chain' do
    hash = Kitsune::Hash.chain_hash 'test'
    expect(hash.to_hex).to eql('954d5a49fd70d9b8bcdb35d252267829957f7ef7fa6c74f88419bdc5e82209f4')
  end

  it 'can get hash from the chain at the specified index' do
    hash = Kitsune::Hash.chain_hash 'test', index: 5
    expect(hash.to_hex).to eql('a87f29c415e1a0edd31133a72d583ed6fb81ffd0c8b07b931491bc1a67da6a57')
  end
end
