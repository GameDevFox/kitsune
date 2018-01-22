require_relative 'graph_spec_helper'

using Kitsune::Refine

module QueryResultSpec
  include GraphSpecHelper

  RSpec.describe Kitsune::Graph::QueryResult do
    before(:each) do
      @edges = GraphSpecHelper.sample_edges
      @edges = GraphSpecHelper.sample_edges_b @edges
      @type_edges = GraphSpecHelper.add_some_edges @edges

      @edges.create_type 'Alice'.to_hex, 'Bob'.to_hex, PARENT
    end

    it 'should return uniq results' do
      result = @edges.search head: 'Alice'.to_hex, type: NAME
      expect(result.heads).to eql ['Alice'.to_hex]
    end

    it 'should be able to get heads' do
      result = @edges.search tail: 'b'.to_hex, type: NAME
      expect(result.heads).to eql %w(Bob Robert).map { |x| x.to_hex }
    end

    it 'should be able to get tails' do
      result = @edges.search head: 'Alice'.to_hex, type: NAME
      expect(result.tails).to eql %w(a aa).map { |x| x.to_hex }
    end

    it 'should be able to get types' do
      result = @edges.search head: 'Alice'.to_hex
      expect(result.types).to eql %w(name parent).map { |x| x.to_hex }
    end

    it 'should be able to get edge_nodes' do
      result = @edges.search type: NAME
      expect(result.edge_nodes).to contain_exactly *(@type_edges.map{ |edge| edge[0] })
    end

    it 'should be able to get type_edge_nodes' do
      result = @edges.search type: NAME
      expect(result.type_edge_nodes).to contain_exactly *(@type_edges.map{ |edge| edge[1] })
    end
  end

end
