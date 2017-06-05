require 'spec_helper'

RSpec.describe 'kitsune/extend' do
  it 'String can be cast to hex' do
    expect('hello'.to_hex).to eql '68656c6c6f'
  end

  it 'String can be incremented' do
    expect('hello'.incr).to eql 'iello'
  end

  it 'String can be incremented by a certain amount' do
    expect('hello'.incr(10000).bytes).to eql "x\x8Cllo".bytes
  end
end
