using Kitsune::Refine

class Kitsune::Systems::ListSystem
  include Kitsune::Nodes
  include Kitsune::System

  def initialize(system)
    @system = system
  end

  command ~[WRITE, LIST] do |list|
    list_hash = Kitsune::Hash.list_hash list

    container = list_hash
    list.each { |item|
      container = @system.command ~[WRITE, EDGE], { head: container, tail: item }
    }

    list_hash
  end

  command ~[READ, LIST] do |list_node|
    edge = @system.command ~[SEARCH, EDGE], { head: list_node }

    list = []
    until edge.empty?
      throw 'There are more then one child node in a list' if edge.size > 1

      item, container = edge[0].values_at 'tail', 'edge'
      list << item

      edge = @system.command ~[SEARCH, EDGE], { head: container }
    end

    list
  end
end
