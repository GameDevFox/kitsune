using Kitsune::Refine

class Kitsune::Systems::NameSystem
  include Kitsune::System

  def initialize(system)
    @system = system
  end

  command ~[ADD, NAME] do |input|
    str_node = @system.command ~[WRITE, STRING], input[:name]
    @system.command ~[WRITE, RELATION], { head: str_node, tail: input[:node], type: NAME }
  end

  command ~[REMOVE, NAME] do |name_node|
    @system.command ~[DELETE, RELATION], name_node
  end

  command ~[LIST, [NODE, NAME]] do |node|
    name_nodes = @system.command ~[LIST, [RELATION, NODE]], { node: node, type: NAME }
    name_nodes.map { |name_node| @system.command ~[READ, STRING], name_node }
  end

  command ~[LIST, [NAME, NODE]] do |name|
    name_node = @system.command ~[WRITE, STRING], name
    @system.command ~[LIST, [NODE, RELATION]], { node: name_node, type: NAME }
  end
end
