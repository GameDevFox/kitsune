require 'spec_helper'

module SQLite3GraphSpec
  include GraphSpecHelper

  RSpec.describe Kitsune::Graph::SQLite3Edges do

    before(:each) do
      db = GraphSpecHelper.create_db
      @edges = Kitsune::Graph::SQLite3Edges.new db

      @edge = @edges.create_edge 'head', 'tail'
    end

    it 'should return the edge' do
      expect(@edge[0..1]).to eql %w(head tail)
      expect(@edge[2].to_hex).to eql '83cacc2787dbf0a7e81fa3304be07f1c683ff968f4105b3318141522a9face1f'
    end

    it 'should be able to get edges' do
      edge = @edges.get_edges @edge
      expect(edge[0][0..1]).to eql %w(head tail)
      expect(edge[0][2].to_hex).to eql '83cacc2787dbf0a7e81fa3304be07f1c683ff968f4105b3318141522a9face1f'
    end

    it 'should be able to search edges' do
      @edges.create_edge 'A', 'B'
      @edges.create_edge 'B', 'C'
      @edges.create_edge 'C', 'A'
      @edges.create_edge 'A', 'D'
      @edges.create_edge 'X', 'D'

      result = @edges.search_edges
      expect(result.size).to be 6

      result = @edges.search_edges 'A'
      expect(result.size).to be 2

      result = @edges.search_edges nil, 'D'
      expect(result.size).to be 2

      result = @edges.search_edges 'A', 'D'
      expect(result.size).to be 1
    end
  end

end

