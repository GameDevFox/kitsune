module Kitsune
  module Graph

    class InversePathGraph

      N = Kitsune::Nodes

      def initialize(edge_source)
        @edge_source = edge_source
      end

      def travel(node, path)
        inv_path = inverse_path path
        inv_path ? @edge_source.search(tail: node, rel: inv_path).heads : []
      end

      private
      def inverse_path(path)
        @edge_source.search(head: path, rel: N::INVERSE_PATH).tails[0] || @edge_source.search(tail: path, rel: N::INVERSE_PATH).heads[0]
      end
    end

  end
end
