using Kitsune::Refine

class Kitsune::Systems::GroupSystem
  include Kitsune::Nodes
  include Kitsune::System

  def initialize(system)
    @system = system
  end

  command ~[WRITE, GROUP] do |group|
    group_node = Kitsune::Hash.group_hash group

    edges = group.map { |node| { head: group_node, tail: node } }
    @system.execute ~[WRITE, EDGE], edges

    group_node
  end

  command ~[READ, GROUP] do |group_node|
    edges = @system.execute ~[SEARCH, EDGE], { head: group_node }
    edges.map { |edge| edge['tail'] }
  end
end
