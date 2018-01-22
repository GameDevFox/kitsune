require_relative 'graph_spec_helper'

using Kitsune::Refine

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
      result = @graph['tail'.to_hex] * HEAD
      expect(result).to eql ['head'.to_hex]
    end

    it 'should be able to travel tail paths' do
      result = @graph['head'.to_hex] * TAIL
      expect(result).to eql ['tail'.to_hex]
    end

    it 'should work with relationship paths' do
      result = @graph['brother'.to_hex] * SIBLING
      expect(result).to eql ['sister'.to_hex]

      result = @graph[PARENT] * INVERSE_PATH
      expect(result).to eql [CHILD]
    end

    it 'should work with bi-directional paths' do
      result = @graph['sister'.to_hex] * SIBLING
      expect(result).to eql ['brother'.to_hex]

      result = @graph[CHILD] * INVERSE_PATH
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
      result = @graph['father'.to_hex] * CHILD
      expect(result).to eql ['son'.to_hex]

      result = @graph['son'.to_hex] * PARENT
      expect(result).to eql ['father'.to_hex]
    end
  end

end
