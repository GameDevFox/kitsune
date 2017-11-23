using Kitsune::Refine

module Kitsune::Name
  class System
    include Kitsune::System

    def initialize(base, dict_node)
      @base = base
      @dict_node = dict_node
    end

    command ~[ADD, NAME] do |input|
      str_node = @base.command ~[WRITE, STRING], input[:name]

      rel_node = @base.command ~[WRITE, RELATION], { head: str_node, tail: input[:node], type: NAME }
      @base.command ~[WRITE, EDGE], { head: @dict_node, tail: rel_node }
    end

    command ~[REMOVE, NAME] do |dict_node|
      name_node = @base.command(~[READ, EDGE], dict_node)['tail']

      @base.command ~[DELETE, EDGE], dict_node
      @base.command ~[DELETE, RELATION], name_node
    end

    command ~[LIST, [NODE, NAME]] do |node|
      result = @base.command ~[SEARCH, RELATION], { tail: node, type: NAME }
      dict_edges = @base.command ~[SEARCH, EDGE], { head: @dict_node, tail: result.type_edge_nodes }
      valid_type_edges = dict_edges.map { |edge| edge['tail'] }
      valid_edges = result.type_edges.select { |edge| valid_type_edges.include? edge['edge'] }.map { |edge| edge['tail'] }
      edges = result.edges.select { |edge| valid_edges.include? edge['edge'] }
      name_nodes = edges.map { |edge| edge['head'] }

      name_nodes.map { |name| @base.command ~[READ, STRING], name }
    end

    command ~[LIST, [NAME, NODE]] do |name|
      name_nodes = Array(name).map { |name| @base.command ~[WRITE, STRING], name }

      result = @base.command ~[SEARCH, RELATION], { head: name_nodes, type: NAME }
      dict_edges = @base.command ~[SEARCH, EDGE], { head: @dict_node, tail: result.type_edge_nodes }
      valid_type_edges = dict_edges.map { |edge| edge['tail'] }
      valid_edges = result.type_edges.select { |edge| valid_type_edges.include? edge['edge'] }.map { |edge| edge['tail'] }
      edges = result.edges.select { |edge| valid_edges.include? edge['edge'] }

      edges.map { |edge| edge['tail'] }
    end
  end
end
