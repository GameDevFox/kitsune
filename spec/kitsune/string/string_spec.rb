require 'spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::String::System do
    before(:each) do
      db = SQLite3::Database.new ':memory:'
      Kitsune::String::System.init db
      @strings = Kitsune::String::System.new db

      @hash_a = @strings.command ~[WRITE, STRING], 'Hello World'
      @hash_b = @strings.command ~[WRITE, STRING], 'Another one'
    end

    it 'should be able to write strings' do
      expect(@hash_a.to_hex).to eq 'a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e'
      expect(@hash_b.to_hex).to eq 'b9eb18a804cf0c50a777fd8aebe108a909ef8f27c720b8468af5f7836f8b5140'
    end

    it 'should be able to read strings' do
      string_a = @strings.command ~[READ, STRING], @hash_a
      string_b = @strings.command ~[READ, STRING], @hash_b
      string_c = @strings.command ~[READ, STRING], 'abcd'

      expect(string_a).to eq 'Hello World'
      expect(string_b).to eq 'Another one'
      expect(string_c).to eq nil
    end
  end

end
