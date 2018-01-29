require 'sqlite3'

require 'spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Coders::RubyCoder do
    before(:each) do
      db = SQLite3::Database.new ':memory:'

      @system = Kitsune::Systems::SuperSystem.new

      @system << Kitsune::Systems::SQLite3EdgeSystem.new(db)
      @system << Kitsune::Systems::StringSystem.new(db)
      @system << Kitsune::Systems::IntegerSystem.new

      @system << Kitsune::Systems::RelationSystem.new(@system)
      @system << Kitsune::Systems::ListSystem.new(@system)

      @ruby_coder = Kitsune::Coders::RubyCoder.new @system
      @system << @ruby_coder

      # Configure string read and write method
      @system.command ~[WRITE, RELATION], { head: STRING, type: ~[SYSTEM, READ], tail: ~[READ, STRING] }
      @system.command ~[WRITE, RELATION], { head: INTEGER, type: ~[SYSTEM, READ], tail: ~[READ, INTEGER] }
      @system.command ~[WRITE, RELATION], { head: ~[WRITE, STD_OUT], type: ~[SYSTEM, READ], tail: CODE }
      @system.command ~[WRITE, RELATION], { head: LIST, type: ~[SYSTEM, READ], tail: ~[READ, LIST] }
    end

    it 'should code string' do
      string_node = @system.command ~[WRITE, STRING], 'Hello "World" - one \ two'
      edge = @system.command ~[WRITE, EDGE], { head: STRING, tail: string_node }

      code = @ruby_coder.command CODE, edge
      expect(code).to eq %{"Hello \\"World\\" - one \\\\ two"}
    end

    it 'should code integer' do
      integer_node = @system.command ~[WRITE, INTEGER], 1234567890
      edge = @system.command ~[WRITE, EDGE], { head: INTEGER, tail: integer_node }

      code = @ruby_coder.command CODE, edge
      expect(code).to eq '1234567890'
    end

    it 'should code write_to_stdout with string output' do
      string_node = @system.command ~[WRITE, STRING], 'Hello "Coder" World'
      string_edge = @system.command ~[WRITE, EDGE], { head: STRING, tail: string_node }
      edge = @system.command ~[WRITE, EDGE], { head: ~[WRITE, STD_OUT], tail: string_edge }

      code = @ruby_coder.command CODE, edge
      expect(code).to eq 'puts "Hello \"Coder\" World"'
    end

    it 'should code write_to_stdout with integer output' do
      integer_node = @system.command ~[WRITE, INTEGER], 54321
      integer_edge = @system.command ~[WRITE, EDGE], { head: INTEGER, tail: integer_node }
      edge = @system.command ~[WRITE, EDGE], { head: ~[WRITE, STD_OUT], tail: integer_edge }

      code = @ruby_coder.command CODE, edge
      expect(code).to eq 'puts 54321'
    end

    it 'should code list' do
      first_node = @system.command ~[WRITE, STRING], 'He says he\'s a "doctor"'
      first_edge = @system.command ~[WRITE, EDGE], { head: STRING, tail: first_node }
      first = @system.command ~[WRITE, EDGE], { head: ~[WRITE, STD_OUT], tail: first_edge }

      second_node = @system.command ~[WRITE, INTEGER], 8128
      second_edge = @system.command ~[WRITE, EDGE], { head: INTEGER, tail: second_node }
      second = @system.command ~[WRITE, EDGE], { head: ~[WRITE, STD_OUT], tail: second_edge }

      third_node = @system.command ~[WRITE, STRING], 'It\'s is Wonderful Life'
      third_edge = @system.command ~[WRITE, EDGE], { head: STRING, tail: third_node }
      third = @system.command ~[WRITE, EDGE], { head: ~[WRITE, STD_OUT], tail: third_edge }

      list = @system.command ~[WRITE, LIST], [first, second, third]
      edge = @system.command ~[WRITE, EDGE], { head: LIST, tail: list }

      code = @ruby_coder.command CODE, edge
      expect(code).to eq <<~EOF.chomp
        puts "He says he's a \\"doctor\\""
        puts 8128
        puts "It's is Wonderful Life"
      EOF
    end
  end
end
