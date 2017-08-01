module Kitsune
  module Graph

    class RelationshipGraph

      N = Kitsune::Nodes

      def initialize(edge_source)
        @edge_source = edge_source
      end

      def travel(node, path)
        @edge_source.search(head: node, rel: path).tails
      end
    end

  end
end
