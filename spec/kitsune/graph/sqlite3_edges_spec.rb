require_relative 'graph_spec_helper'

using Kitsune::Refine

RSpec.describe Kitsune::Graph::SQLite3Edges do
  before(:each) do
    @db = GraphSpecHelper.create_db
    @edges = Kitsune::Graph::SQLite3Edges.new @db

    @edge = @edges.create_edge 'head', 'tail'
  end

  it 'should be able to get edges' do
    edge = @edges.get_edges(@edge)[0]

    expect(edge['head']).to eql 'head'
    expect(edge['tail']).to eql 'tail'
    expect(edge[2].to_hex).to eql('87c2aebe999878ed1c244b6a85d1a2ad0b5c6f0916afed00797c1bc7d6097961')
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
