module Kitsune
  module Graph

    class QueryResult
      attr_reader :edges

      def initialize(edges, base_edges, rel_edges)
        @edges = edges
        @base_edges = base_edges
        @rel_edges = rel_edges
      end

      def edges
        @base_edges ||= @edges.get_edges rel_edges.map{ |edge| edge[1] }
      end

      def rel_edges
        @rel_edges ||= @edges.search_edges nil, edge_nodes
      end

      def heads
        edges.map { |edge| edge[0] }.uniq
      end

      def tails
        edges.map { |edge| edge[1] }.uniq
      end

      def rels
        rel_edges.map { |edge| edge[0] }.uniq
      end

      def edge_nodes
        edges.map { |edge| edge[2] }.uniq
      end

      def rel_edge_nodes
        rel_edges.map { |edge| edge[2] }.uniq
      end
    end

  end
end
