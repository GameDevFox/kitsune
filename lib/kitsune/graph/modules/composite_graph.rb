module Kitsune
  module Graph

    module CompositeGraph
      def self.new(*graphs)
        graphs.extend(CompositeGraph)
      end

      def travel(node, path)
        self.flat_map do |graph|
          graph.travel(node, path)
        end
      end
    end

  end
end
