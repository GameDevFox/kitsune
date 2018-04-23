using Kitsune::Refine

class Kitsune::Systems::NameSystem
  include Kitsune::System

  def initialize(system)
    @system = system
  end

  command ~[ADD, NAME] do |input|
    str_node = @system.execute ~[WRITE, STRING], input[:name]
    @system.execute ~[WRITE, RELATION], { head: str_node, tail: input[:node], type: NAME }
  end

  command ~[REMOVE, NAME] do |name_node|
    @system.execute ~[DELETE, RELATION], name_node
  end

  command ~[LIST_V, [NODE, NAME]] do |node|
    name_nodes = @system.execute ~[LIST_V, [RELATION, NODE]], {node: node, type: NAME }
    name_nodes.map { |name_node| @system.execute ~[READ, STRING], name_node }
  end

  command ~[LIST_V, [NAME, NODE]] do |name|
    name_node = @system.execute ~[WRITE, STRING], name
    @system.execute ~[LIST_V, [NODE, RELATION]], {node: name_node, type: NAME }
  end
end
