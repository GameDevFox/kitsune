module Kitsune
  module Graph

    class QueryResult
      attr_reader :edges

      def initialize(edges, base_edges, type_edges)
        @edges = edges
        @base_edges = base_edges
        @type_edges = type_edges
      end

      def edges
        @base_edges ||= @edges.get_edges(type_edges.map{ |edge| edge['tail'] })
      end

      def type_edges
        @type_edges ||= @edges.search_edges nil, edge_nodes
      end

      def heads
        edges.map { |edge| edge['head'] }.uniq
      end

      def tails
        edges.map { |edge| edge['tail'] }.uniq
      end

      def types
        type_edges.map { |edge| edge['head'] }.uniq
      end

      def edge_nodes
        edges.map { |edge| edge['edge'] }.uniq
      end

      def type_edge_nodes
        type_edges.map { |edge| edge['edge'] }.uniq
      end
    end

  end
end
