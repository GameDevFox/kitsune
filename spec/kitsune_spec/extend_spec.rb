require 'spec_helper'

RSpec.describe 'kitsune/extend' do
  it 'String and Array can have binary operations executed against it' do
    expect("\x01\x02\x03\x04".binary_op(:+, "\xff\xa0\xb0\xc0").to_hex).to eql "\x00\xa3\xb3\xc4".to_hex

    # Accepts arrays and integers as well
    expect('hello'.binary_op(:+, [250, 220])).to eql 'bBmlo'
    expect('hello'.binary_op(:+, 2000)).to eql '8mllo'

    # Array examples
    expect([1, 2, 3, 4].binary_op(:+, 'sum')).to eql [116, 119, 112, 4]
    expect([50, 40, 30, 20].binary_op(:+, [250, 220])).to eql [44, 5, 31, 20]
    expect([1, 2, 3, 4].binary_op(:+, 2000)).to eql [209, 9, 3, 4]
  end

  it 'String can be cast to hex' do
    expect('hello'.to_hex).to eql '68656c6c6f'
  end

  it 'Array can be cast to Integer' do
    expect([4, 3, 2, 1].to_i).to eql 16909060
  end

  it 'Integer can be cast to Array' do
    expect(16909060.to_a).to eql [4, 3, 2, 1]
  end
end
