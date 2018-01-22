require_relative 'graph_spec_helper'

using Kitsune::Refine

RSpec.describe Kitsune::Graph::SQLite3Edges do
  before(:each) do
    @db = GraphSpecHelper.create_db
    @edges = Kitsune::Graph::SQLite3Edges.new @db

    @edge = @edges.create_edge 'head' .to_hex, 'tail'.to_hex
  end

  it 'should be able to get edges' do
    edge = @edges.get_edges(@edge)[0]

    expect(edge['head']).to eql 'head'.to_hex
    expect(edge['tail']).to eql 'tail'.to_hex
    expect(edge[2]).to eql('87c2aebe999878ed1c244b6a85d1a2ad0b5c6f0916afed00797c1bc7d6097961')
  end

  it 'should be able to search edges' do
    @edges.create_edge 'A'.to_hex, 'B'.to_hex
    @edges.create_edge 'B'.to_hex, 'C'.to_hex
    @edges.create_edge 'C'.to_hex, 'A'.to_hex
    @edges.create_edge 'A'.to_hex, 'D'.to_hex
    @edges.create_edge 'X'.to_hex, 'D'.to_hex

    result = @edges.search_edges
    expect(result.size).to be 6

    result = @edges.search_edges 'A'.to_hex
    expect(result.size).to be 2

    result = @edges.search_edges nil, 'D'.to_hex
    expect(result.size).to be 2

    result = @edges.search_edges 'A'.to_hex, 'D'.to_hex
    expect(result.size).to be 1
  end
end
