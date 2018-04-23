require 'sqlite3'

require_relative '../spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Coders::RubyCoder do
    before(:each) do
      db = SQLite3::Database.new ':memory:'

      @base_system = Kitsune::Systems::SuperSystem.new
      @base_system << Kitsune::Systems::SQLite3EdgeSystem.new(db)
      @base_system << Kitsune::Systems::StringSystem.new(db)
      @base_system << Kitsune::Systems::IntegerSystem.new
      @base_system << Kitsune::Systems::RelationSystem.new(@base_system)
      @base_system << Kitsune::Systems::ListSystem.new(@base_system)
      @base_system << Kitsune::Systems::TypeGraphSystem.new(@base_system)

      @system = Kitsune::Systems::SuperSystem.new

      ruby_coder = Kitsune::Coders::RubyCoder.new(@system)
      common_coder = Kitsune::Coders::CommonCoder.new(ruby_coder)

      @system << @base_system
      @system << common_coder
      @system << ruby_coder

      @system.execute INIT
    end

    it 'should code string' do
      string_node = @base_system.execute ~[WRITE, STRING], 'Hello "World" - one \ two'
      edge = @base_system.execute ~[WRITE, EDGE], { head: STRING, tail: string_node }

      code = @system.execute CODE, edge
      expect(code).to eq %{"Hello \\"World\\" - one \\\\ two"}
    end

    it 'should code integer' do
      integer_node = @base_system.execute ~[WRITE, INTEGER], 1234567890
      edge = @base_system.execute ~[WRITE, EDGE], { head: INTEGER, tail: integer_node }

      code = @system.execute CODE, edge
      expect(code).to eq '1234567890'
    end

    it 'should code write_to_stdout with string output' do
      string_node = @base_system.execute ~[WRITE, STRING], 'Hello "Coder" World'
      string_edge = @base_system.execute ~[WRITE, EDGE], { head: STRING, tail: string_node }
      edge = @base_system.execute ~[WRITE, EDGE], { head: ~[WRITE, STD_OUT], tail: string_edge }

      code = @system.execute CODE, edge
      expect(code).to eq 'puts "Hello \"Coder\" World"'
    end

    it 'should code write_to_stdout with integer output' do
      integer_node = @base_system.execute ~[WRITE, INTEGER], 54321
      integer_edge = @base_system.execute ~[WRITE, EDGE], { head: INTEGER, tail: integer_node }
      edge = @base_system.execute ~[WRITE, EDGE], { head: ~[WRITE, STD_OUT], tail: integer_edge }

      code = @system.execute CODE, edge
      expect(code).to eq 'puts 54321'
    end

    it 'should code list' do
      first_node = @base_system.execute ~[WRITE, STRING], 'He says he\'s a "doctor"'
      first_edge = @base_system.execute ~[WRITE, EDGE], { head: STRING, tail: first_node }
      first = @base_system.execute ~[WRITE, EDGE], { head: ~[WRITE, STD_OUT], tail: first_edge }

      second_node = @base_system.execute ~[WRITE, INTEGER], 8128
      second_edge = @base_system.execute ~[WRITE, EDGE], { head: INTEGER, tail: second_node }
      second = @base_system.execute ~[WRITE, EDGE], { head: ~[WRITE, STD_OUT], tail: second_edge }

      third_node = @base_system.execute ~[WRITE, STRING], 'It\'s is Wonderful Life'
      third_edge = @base_system.execute ~[WRITE, EDGE], { head: STRING, tail: third_node }
      third = @base_system.execute ~[WRITE, EDGE], { head: ~[WRITE, STD_OUT], tail: third_edge }

      list = @base_system.execute ~[WRITE, LIST_N], [first, second, third]
      edge = @base_system.execute ~[WRITE, EDGE], {head: LIST_N, tail: list }

      code = @system.execute CODE, edge
      expect(code).to eq <<~EOF.chomp
        puts "He says he's a \\"doctor\\""
        puts 8128
        puts "It's is Wonderful Life"
      EOF
    end
  end
end
