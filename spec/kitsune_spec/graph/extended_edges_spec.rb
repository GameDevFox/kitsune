require_relative 'graph_spec_helper'

module ExtendedEdgesSpec
  include GraphSpecHelper

  RSpec.describe Kitsune::Graph::ExtendedEdges do
    before(:each) do
      @edges = GraphSpecHelper.sample_edges
      @edges = GraphSpecHelper.sample_edges_b @edges
      GraphSpecHelper.add_some_edges @edges
    end

    context 'should be able to search' do
      it 'all' do
        result = @edges.search

        expect(result.edges.size).to be 27
        expect(result.rel_edges.size).to be 9
      end

      it 'tails' do
        result = @edges.search head: SAME_GROUP
        expect(result.edges.size).to be 4
        expect(result.rel_edges.size).to be 0
      end

      it 'heads' do
        result = @edges.search tail: 'tail'
        expect(result.edges.size).to be 2
        expect(result.rel_edges.size).to be 0
      end

      it 'edges' do
        result = @edges.search head: SAME_GROUP, tail: CHILD_B
        expect(result.edges[0]['edge'].to_hex).to eql('ad19b9a6775c62d18037b3b65544f9adbc92a42fb0a3f3b4f1ade8c9da1a6893')
        expect(result.rel_edges.size).to be 0
      end

      it 'relationship edges' do
        result = @edges.search rel: NAME
        expect(result.edges.size).to be 5
        expect(result.rel_edges.size).to be 5
      end

      it 'tail relationships' do
        result = @edges.search head: 'Alice', rel: NAME
        expect(result.edges.size).to be 2
        expect(result.rel_edges.size).to be 2
      end

      it 'head relationships' do
        result = @edges.search tail: 'b', rel: NAME
        expect(result.edges.size).to be 2
        expect(result.rel_edges.size).to be 2
      end

      it 'relationships' do
        result = @edges.search head: 'Alice', tail: 'a', rel: NAME
        expect(result.edges.size).to be 1
        expect(result.rel_edges.size).to be 1
      end
    end
  end

end
