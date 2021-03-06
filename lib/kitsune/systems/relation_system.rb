using Kitsune::Refine

class Kitsune::Systems::RelationSystem
  include Kitsune::Nodes
  include Kitsune::System

  def initialize(system)
    @system = system
  end

  command ~[WRITE, RELATION] do |relation|
    edge = @system.execute ~[WRITE, EDGE], { head: relation[:head], tail: relation[:tail] }
    @system.execute ~[WRITE, EDGE], { head: relation[:type], tail: edge }
  end

  command ~[DELETE, RELATION] do |relation|
    type_edge = @system.execute ~[READ, EDGE], relation

    @system.execute ~[DELETE, EDGE], type_edge['tail']
    @system.execute ~[DELETE, EDGE], relation
  end

  def list_node_relation(node_key, relation_key, criteria)
    edges = @system.execute ~[SEARCH, EDGE], { node_key => criteria[:node] }
    edge_ids = edges.map { |edge| edge['edge'] }

    type_edges = @system.execute ~[SEARCH, EDGE], { head: criteria[:type], tail: edge_ids }
    type_edge_tails = type_edges.map { |edge| edge['tail'] }

    filtered_edges = edges.select { |edge| type_edge_tails.include?(edge['edge']) }
    filtered_edges.map { |edge| edge[relation_key.to_s] }
  end

  command ~[LIST_V, [NODE, RELATION]] do |criteria|
    list_node_relation :head, :tail, criteria
  end

  command ~[LIST_V, [RELATION, NODE]] do |criteria|
    list_node_relation :tail, :head, criteria
  end
end
