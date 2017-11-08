module Kitsune
  module Graph

    module ExtendedEdges

      N = Kitsune::Nodes

      def create_rel(head, tail, type)
        edge = create_edge head, tail
        create_edge type, edge
      end

      def search(head: nil, tail: nil, rel: nil)
        # Get base_edges
        base_edges = (head || tail || !rel) ? search_edges(head, tail) : nil

        # Filter base_edges by rel
        rel_edges = nil
        if rel
          edge_ids = base_edges&.map { |edge| edge['edge'] }
          rel_edges = search_edges rel, edge_ids
          if base_edges
            rel_edge_tails = rel_edges.map { |edge| edge['tail'] }
            base_edges.select! { |edge| rel_edge_tails.include? edge['edge'] }
          end
        end

        QueryResult.new(self, base_edges, rel_edges)
      end
    end

  end
end
