require_relative 'graph_spec_helper'

module QueryResultSpec
  include GraphSpecHelper

  RSpec.describe Kitsune::Graph::QueryResult do
    before(:each) do
      @edges = GraphSpecHelper.sample_edges
      @edges = GraphSpecHelper.sample_edges_b @edges
      @rel_edges = GraphSpecHelper.add_some_edges @edges

      @edges.create_rel 'Alice', 'Bob', PARENT
    end

    it 'should return uniq results' do
      result = @edges.search head: 'Alice', rel: NAME
      expect(result.heads).to eql ['Alice']
    end

    it 'should be able to get heads' do
      result = @edges.search tail: 'b', rel: NAME
      expect(result.heads).to eql %w(Bob Robert)
    end

    it 'should be able to get tails' do
      result = @edges.search head: 'Alice', rel: NAME
      expect(result.tails).to eql %w(a aa)
    end

    it 'should be able to get rels' do
      result = @edges.search head: 'Alice'
      expect(result.rels).to eql %w(name parent)
    end

    it 'should be able to get edge_nodes' do
      result = @edges.search rel: NAME
      actual = @edges.get_edges(@rel_edges).map { |edge| edge['tail'] }

      expect(result.edge_nodes).to contain_exactly *actual
    end

    it 'should be able to get rel_edge_nodes' do
      result = @edges.search rel: NAME
      expect(result.rel_edge_nodes).to eql @rel_edges
    end
  end

end
