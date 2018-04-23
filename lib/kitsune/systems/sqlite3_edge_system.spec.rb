require_relative '../spec_helper'

require 'sqlite3'

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

  RSpec.describe Kitsune::Systems::SQLite3EdgeSystem do
    before(:each) do
      db = SQLite3::Database.new ':memory:'
      @graph = Kitsune::Systems::SQLite3EdgeSystem.new(db)

      @edge_node = @graph.execute ~[WRITE, EDGE], { head: HELLO, tail: WORLD }
    end

    it 'should be able to count edges' do
      @graph.execute ~[WRITE, EDGE], { head: ONE, tail: TWO }
      @graph.execute ~[WRITE, EDGE], { head: THREE, tail: FOUR }
      @graph.execute ~[WRITE, EDGE], { head: FIVE, tail: SIX }

      count = @graph.execute ~[COUNT, EDGE]
      expect(count).to be 4
    end

    it 'should be able to write edges' do
      expect(@edge_node).to eq '0774ece1e9aa64718b581f70362ef880ad9eea36a202b1e1c875f89bd302dcac'
    end

    it 'should be able to safely write the same edge multiple times' do
      edge_b = @graph.execute ~[WRITE, EDGE], { head: HELLO, tail: WORLD }
      edge_c = @graph.execute ~[WRITE, EDGE], { head: HELLO, tail: WORLD }

      expect(@edge_node).to eq edge_b
      expect(@edge_node).to eq edge_c
    end

    it 'should be able to read edges' do
      edge = @graph.execute ~[READ, EDGE], @edge_node
      expect(edge).to eq ({ 'edge' => @edge_node, 'head' => HELLO, 'tail' => WORLD })
    end

    it 'should be able to remove edges' do
      @graph.execute ~[DELETE, EDGE], @edge_node
    end

    it 'should be able to list all edges' do
      another_edge_node = @graph.execute ~[WRITE, EDGE], { head: 'another'.to_hex, tail: ONE }
      all_edges = @graph.execute ~[LIST_V, EDGE]

      expect(all_edges).to eq [
        { 'edge' => @edge_node, 'head' => HELLO, 'tail' => WORLD },
        { 'edge' => another_edge_node, 'head' => 'another'.to_hex, 'tail' => ONE }
      ]
    end

    it 'should be able to search edges' do
      @graph.execute ~[WRITE, EDGE], { head: 'alpha'.to_hex, tail: ONE }
      edge = @graph.execute ~[WRITE, EDGE], { head: 'alpha'.to_hex, tail: TWO }
      @graph.execute ~[WRITE, EDGE], { head: 'beta'.to_hex, tail: THREE }
      @graph.execute ~[WRITE, EDGE], { head: 'beta'.to_hex, tail: ONE }

      result = @graph.execute ~[SEARCH, EDGE], { head: 'alpha'.to_hex }
      expect(result.size).to eq 2
      expect(result.any? { |x| x['head'] == 'alpha'.to_hex && x['tail'] == ONE }).to be true
      expect(result.any? { |x| x['head'] == 'alpha'.to_hex && x['tail'] == TWO }).to be true

      result = @graph.execute ~[SEARCH, EDGE], { tail: ONE }
      expect(result.size).to eq 2
      expect(result.any? { |x| x['head'] == 'alpha'.to_hex && x['tail'] == ONE }).to be true
      expect(result.any? { |x| x['head'] == 'beta'.to_hex && x['tail'] == ONE }).to be true

      result = @graph.execute ~[SEARCH, EDGE], { head: 'beta'.to_hex, tail: THREE }
      expect(result.size).to eq 1
      expect(result[0]).to include({ 'head' => 'beta'.to_hex, 'tail' => THREE })

      result = @graph.execute ~[SEARCH, EDGE], { edge: edge }
      expect(result.size).to eq 1
      expect(result[0]).to include({ 'edge' => edge, 'head' => 'alpha'.to_hex, 'tail' => TWO })

      result = @graph.execute ~[SEARCH, EDGE], { edge: edge, head: 'alpha'.to_hex, tail: TWO }
      expect(result.size).to eq 1
      expect(result[0]).to include({ 'edge' => edge, 'head' => 'alpha'.to_hex, 'tail' => TWO })
    end
  end

end

