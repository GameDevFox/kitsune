require_relative '../spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Systems::StringSystem do
    before(:each) do
      db = SQLite3::Database.new ':memory:'
      @strings = Kitsune::Systems::StringSystem.new db

      @hash_a = @strings.execute ~[WRITE, STRING], 'Hello World'
      @hash_b = @strings.execute ~[WRITE, STRING], 'Another one'
    end

    it 'should be able to write strings' do
      expect(@hash_a).to eq 'a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e'
      expect(@hash_b).to eq 'b9eb18a804cf0c50a777fd8aebe108a909ef8f27c720b8468af5f7836f8b5140'
    end

    it 'should be able to read strings' do
      string_a = @strings.execute ~[READ, STRING], @hash_a
      string_b = @strings.execute ~[READ, STRING], @hash_b
      string_c = @strings.execute ~[READ, STRING], 'abcd'

      expect(string_a).to eq 'Hello World'
      expect(string_b).to eq 'Another one'
      expect(string_c).to eq nil
    end
  end

end
