using Kitsune::Refine

module Kitsune::Graph::Relation
  class System
    include Kitsune::Nodes
    include Kitsune::System

    def initialize(base)
      @base = base
    end

    command ~[WRITE, RELATION] do |relation|
      edge = @base.command ~[WRITE, EDGE], { head: relation[:head], tail: relation[:tail] }
      @base.command ~[WRITE, EDGE], { head: relation[:type], tail: edge }
    end

    command ~[DELETE, RELATION] do |relation|
      type_edge = @base.command ~[READ, EDGE], relation

      @base.command ~[DELETE, EDGE], type_edge['tail']
      @base.command ~[DELETE, EDGE], relation
    end

    command ~[SEARCH, RELATION] do |criteria|
      # Get base_edges
      base_edges = nil
      if criteria[:head] || criteria[:tail] || !criteria[:type]
        base_edges = @base.command ~[SEARCH, EDGE], { head: criteria[:head], tail: criteria[:tail] }
      end

      # Filter base_edges by type
      type_edges = nil
      if criteria[:type]
        edge_ids = base_edges&.map { |edge| edge['edge'] }
        type_edges = @base.command ~[SEARCH, EDGE], { head: criteria[:type], tail: edge_ids }
        if base_edges
          type_edge_tails = type_edges.map { |edge| edge['tail'] }
          base_edges.select! { |edge| type_edge_tails.include? edge['edge'] }
        end
      end

      Kitsune::Graph::QueryResult.new(self, base_edges, type_edges)
    end

    command ~[READ, [NODE, RELATION]] do |criteria|

    end

    command ~[READ, [RELATION, NODE]] do |criteria|

    end
  end
end
