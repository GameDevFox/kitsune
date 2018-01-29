require 'sqlite3'

require 'spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  HELLO = 'hello'.to_hex
  WORLD = 'world'.to_hex
  
  ONE = 'one'.to_hex
  TWO = 'two'.to_hex
  THREE = 'three'.to_hex
  FOUR = 'four'.to_hex
  FIVE = 'five'.to_hex
  SIX = 'six'.to_hex

  class InitTester
    include Kitsune::System
    include Kitsune::Nodes

    attr_reader :init, :init_edge

    command INIT do
      @init = true
    end

    command ~[INIT, [SYSTEM, EDGE]] do
      @init_edge = true
    end
  end

  RSpec.describe Kitsune::Systems::SQLite3EdgeSystem do
    before(:each) do
      db = SQLite3::Database.new ':memory:'

      system = Kitsune::Systems::SuperSystem.new

      @graph = Kitsune::Systems::SQLite3EdgeSystem.new(db, system: system)
      @init_tester = InitTester.new

      system << @graph
      system << @init_tester

      system.command INIT

      @edge_node = @graph.command ~[WRITE, EDGE], { head: HELLO, tail: WORLD }
    end

    it 'should handle INIT' do
      expect(@init_tester.init).to be true
      expect(@init_tester.init_edge).to be true
    end

    it 'should be able to count edges' do
      @graph.command ~[WRITE, EDGE], { head: ONE, tail: TWO }
      @graph.command ~[WRITE, EDGE], { head: THREE, tail: FOUR }
      @graph.command ~[WRITE, EDGE], { head: FIVE, tail: SIX }

      count = @graph.command ~[COUNT, EDGE]
      expect(count).to be 4
    end

    it 'should be able to write edges' do
      expect(@edge_node).to eq '0774ece1e9aa64718b581f70362ef880ad9eea36a202b1e1c875f89bd302dcac'
    end

    it 'should be able to safely write the same edge multiple times' do
      edge_b = @graph.command ~[WRITE, EDGE], { head: HELLO, tail: WORLD }
      edge_c = @graph.command ~[WRITE, EDGE], { head: HELLO, tail: WORLD }

      expect(@edge_node).to eq edge_b
      expect(@edge_node).to eq edge_c
    end

    it 'should be able to read edges' do
      edge = @graph.command ~[READ, EDGE], @edge_node
      expect(edge).to eq ({ 'edge' => @edge_node, 'head' => HELLO, 'tail' => WORLD })
    end

    it 'should be able to remove edges' do
      @graph.command ~[DELETE, EDGE], @edge_node
    end

    it 'should be able to list all edges' do
      another_edge_node = @graph.command ~[WRITE, EDGE], { head: 'another'.to_hex, tail: ONE }
      all_edges = @graph.command ~[LIST, EDGE]

      expect(all_edges).to eq [
        { 'edge' => @edge_node, 'head' => HELLO, 'tail' => WORLD },
        { 'edge' => another_edge_node, 'head' => 'another'.to_hex, 'tail' => ONE }
      ]
    end

    it 'should be able to search edges' do
      @graph.command ~[WRITE, EDGE], { head: 'alpha'.to_hex, tail: ONE }
      edge = @graph.command ~[WRITE, EDGE], { head: 'alpha'.to_hex, tail: TWO }
      @graph.command ~[WRITE, EDGE], { head: 'beta'.to_hex, tail: THREE }
      @graph.command ~[WRITE, EDGE], { head: 'beta'.to_hex, tail: ONE }

      result = @graph.command ~[SEARCH, EDGE], { head: 'alpha'.to_hex }
      expect(result.size).to eq 2
      expect(result.any? { |x| x['head'] == 'alpha'.to_hex && x['tail'] == ONE }).to be true
      expect(result.any? { |x| x['head'] == 'alpha'.to_hex && x['tail'] == TWO }).to be true

      result = @graph.command ~[SEARCH, EDGE], { tail: ONE }
      expect(result.size).to eq 2
      expect(result.any? { |x| x['head'] == 'alpha'.to_hex && x['tail'] == ONE }).to be true
      expect(result.any? { |x| x['head'] == 'beta'.to_hex && x['tail'] == ONE }).to be true

      result = @graph.command ~[SEARCH, EDGE], { head: 'beta'.to_hex, tail: THREE }
      expect(result.size).to eq 1
      expect(result[0]).to include({ 'head' => 'beta'.to_hex, 'tail' => THREE })

      result = @graph.command ~[SEARCH, EDGE], { edge: edge }
      expect(result.size).to eq 1
      expect(result[0]).to include({ 'edge' => edge, 'head' => 'alpha'.to_hex, 'tail' => TWO })

      result = @graph.command ~[SEARCH, EDGE], { edge: edge, head: 'alpha'.to_hex, tail: TWO }
      expect(result.size).to eq 1
      expect(result[0]).to include({ 'edge' => edge, 'head' => 'alpha'.to_hex, 'tail' => TWO })
    end
  end

end

