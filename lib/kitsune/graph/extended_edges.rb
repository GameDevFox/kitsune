module Kitsune
  module Graph

    module ExtendedEdges

      N = Kitsune::Nodes

      def create_rel(head, tail, type)
        edge = create_edge head, tail
        create_edge type, edge[2]
      end

      def search(head: nil, tail: nil, rel: nil)
        # Get base_edges
        base_edges = (head || tail || !rel) ? search_edges(head, tail) : nil

        # Filter base_edges by rel
        rel_edges = nil
        if rel
          edge_ids = base_edges&.map { |edge| edge[2] }
          rel_edges = search_edges rel, edge_ids
          if base_edges
            rel_edge_tails = rel_edges.map { |edge| edge[1] }
            base_edges.select! { |edge| rel_edge_tails.include? edge[2] }
          end
        end

        QueryResult.new(self, base_edges, rel_edges)
      end
    end

  end
end
