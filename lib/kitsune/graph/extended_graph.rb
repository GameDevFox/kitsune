module Kitsune
  module Graph

    module ExtendedGraph
      def get_node(node)
        Kitsune::Graph::Node.new self, node
      end
      alias [] get_node
    end

  end
end
