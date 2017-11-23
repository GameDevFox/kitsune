module Kitsune::Graph::ExtendedEdges

  N = Kitsune::Nodes

  def create_type(head, tail, type)
    edge = create_edge head, tail
    type_edge = create_edge type, edge
    [edge, type_edge]
  end

  def search(head: nil, tail: nil, type: nil)
    # Get base_edges
    base_edges = (head || tail || !type) ? search_edges(head, tail) : nil

    # Filter base_edges by type
    type_edges = nil
    if type
      edge_ids = base_edges&.map { |edge| edge['edge'] }
      type_edges = search_edges type, edge_ids
      if base_edges
        type_edge_tails = type_edges.map { |edge| edge['tail'] }
        base_edges.select! { |edge| type_edge_tails.include? edge['edge'] }
      end
    end

    Kitsune::Graph::QueryResult.new(self, base_edges, type_edges)
  end

end
