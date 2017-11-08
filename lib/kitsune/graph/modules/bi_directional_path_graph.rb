module Kitsune
  module Graph

    class BiDirectionalPathGraph

      N = Kitsune::Nodes

      def initialize(edge_source)
        @edge_source = edge_source
      end

      def travel(node, path)
        result = []
        if is_in? N::BI_DIRECTIONAL_PATHS, path
          result.concat @edge_source.search(tail: node, rel: path).heads

          # Check Bi-Directional groups
          groups = @edge_source.search(head: path, rel: N::BI_DIRECTIONAL_GROUP).tails
          parent_groups = @edge_source.search(head: groups, tail: node).heads

          result.concat @edge_source.search(head: parent_groups).tails unless parent_groups.empty?
        end
        result
      end

      private
      def is_in?(group, node)
        edge = Kitsune::Hash.list_hash([group, node])
        @edge_source.has_edge edge
      end
    end

  end
end
