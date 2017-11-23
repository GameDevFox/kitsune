require 'sqlite3'

require 'spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Graph::SQLite3Graph do
    before(:each) do
      db = SQLite3::Database.new ':memory:'
      Kitsune::Graph::SQLite3Graph.init db

      @graph = Kitsune::Graph::SQLite3Graph.new db
      @edge_node = @graph.command ~[WRITE, EDGE], { head: 'hello', tail: 'world' }
    end

    it 'should be able to count edges' do
      @graph.command ~[WRITE, EDGE], { head: 'one', tail: 'two' }
      @graph.command ~[WRITE, EDGE], { head: 'three', tail: 'four' }
      @graph.command ~[WRITE, EDGE], { head: 'five', tail: 'six' }

      count = @graph.command ~[COUNT, EDGE]
      expect(count).to be 4
    end

    it 'should be able to write edges' do
      expect(@edge_node.to_hex).to eq '0774ece1e9aa64718b581f70362ef880ad9eea36a202b1e1c875f89bd302dcac'
    end

    it 'should be able to safely write the same edge multiple times' do
      edge_b = @graph.command ~[WRITE, EDGE], { head: 'hello', tail: 'world' }
      edge_c = @graph.command ~[WRITE, EDGE], { head: 'hello', tail: 'world' }

      expect(@edge_node).to eq edge_b
      expect(@edge_node).to eq edge_c
    end

    it 'should be able to read edges' do
      edge = @graph.command ~[READ, EDGE], @edge_node
      expect(edge).to eq ({ 'edge' => @edge_node, 'head' => 'hello', 'tail' => 'world' })
    end

    it 'should be able to remove edges' do
      @graph.command ~[DELETE, EDGE], @edge_node
    end

    it 'should be able to list all edges' do
      another_edge_node = @graph.command ~[WRITE, EDGE], { head: 'another', tail: 'one' }
      all_edges = @graph.command ~[LIST, EDGE]

      expect(all_edges).to eq [
        { 'edge' => @edge_node, 'head' => 'hello', 'tail' => 'world' },
        { 'edge' => another_edge_node, 'head' => 'another', 'tail' => 'one' }
      ]
    end

    it 'should be able to search edges' do
      @graph.command ~[WRITE, EDGE], { head: 'alpha', tail: 'one' }
      edge = @graph.command ~[WRITE, EDGE], { head: 'alpha', tail: 'two' }
      @graph.command ~[WRITE, EDGE], { head: 'beta', tail: 'three' }
      @graph.command ~[WRITE, EDGE], { head: 'beta', tail: 'one' }

      result = @graph.command ~[SEARCH, EDGE], { head: 'alpha' }
      expect(result.size).to eq 2
      expect(result.any? { |x| x['head'] == 'alpha' && x['tail'] == 'one' }).to be true
      expect(result.any? { |x| x['head'] == 'alpha' && x['tail'] == 'two' }).to be true

      result = @graph.command ~[SEARCH, EDGE], { tail: 'one' }
      expect(result.size).to eq 2
      expect(result.any? { |x| x['head'] == 'alpha' && x['tail'] == 'one' }).to be true
      expect(result.any? { |x| x['head'] == 'beta' && x['tail'] == 'one' }).to be true

      result = @graph.command ~[SEARCH, EDGE], { head: 'beta', tail: 'three' }
      expect(result.size).to eq 1
      expect(result[0]).to include({ 'head' => 'beta', 'tail' => 'three' })

      result = @graph.command ~[SEARCH, EDGE], { edge: edge }
      expect(result.size).to eq 1
      expect(result[0]).to include({ 'edge' => edge, 'head' => 'alpha', 'tail' => 'two' })

      result = @graph.command ~[SEARCH, EDGE], { edge: edge, head: 'alpha', tail: 'two' }
      expect(result.size).to eq 1
      expect(result[0]).to include({ 'edge' => edge, 'head' => 'alpha', 'tail' => 'two' })
    end
  end

end

