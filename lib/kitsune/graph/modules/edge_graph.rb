module Kitsune
  module Graph

    class EdgeGraph

      N = Kitsune::Nodes

      def initialize(edge_source)
        @edge_source = edge_source
      end

      def travel(node, path)
        result = []
        result.concat @edge_source.search(tail: node).heads if path == N::HEAD
        result.concat @edge_source.search(head: node).tails if path == N::TAIL
        result
      end
    end

  end
end
