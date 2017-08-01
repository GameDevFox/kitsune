require_relative 'graph_spec_helper'

module GraphSpec
  include GraphSpecHelper

  RSpec.describe Kitsune::Graph do
    before(:each) do
      @edges = GraphSpecHelper.sample_edges

      bidir_path_graph = Kitsune::Graph::BiDirectionalPathGraph.new @edges
      edge_graph = Kitsune::Graph::EdgeGraph.new @edges
      inverse_path_graph = Kitsune::Graph::InversePathGraph.new @edges
      rel_graph = Kitsune::Graph::RelationshipGraph.new @edges

      graphs = [bidir_path_graph, edge_graph, inverse_path_graph, rel_graph]
      @graph = Kitsune::Graph::CompositeGraph.new *graphs

      @graph.extend(Kitsune::Graph::ExtendedGraph)
    end

    it 'should be able to travel head paths' do
      result = @graph['tail'] * N::HEAD
      expect(result).to eql ['head']
    end

    it 'should be able to travel tail paths' do
      result = @graph['head'] * N::TAIL
      expect(result).to eql ['tail']
    end

    it 'should work with relationship paths' do
      result = @graph['brother'] * SIBLING
      expect(result).to eql ['sister']

      result = @graph[PARENT] * N::INVERSE_PATH
      expect(result).to eql [CHILD]
    end

    it 'should work with bi-directional paths' do
      result = @graph['sister'] * SIBLING
      expect(result).to eql ['brother']

      result = @graph[CHILD] * N::INVERSE_PATH
      expect(result).to eql [PARENT]
    end

    it 'should work with bi-directional-groups' do
      all_children = [CHILD_A, CHILD_B, CHILD_C, CHILD_D]

      all_children.each do |node|
        result = @graph[node] * SAME
        expect(result).to match_array all_children
      end
    end

    it 'should work with inverse paths' do
      result = @graph['father'] * CHILD
      expect(result).to eql ['son']

      result = @graph['son'] * PARENT
      expect(result).to eql ['father']
    end
  end

end
