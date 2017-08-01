module Kitsune
  module Graph

    class Node
      def initialize(graph, node)
        @edges = graph
        @node = node
      end

      def travel(path)
        @edges.travel(@node, path)
      end
      alias * travel
    end

  end
end
