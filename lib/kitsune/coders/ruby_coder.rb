using Kitsune::Refine

class Kitsune::Coders::RubyCoder
  include Kitsune::Nodes
  include Kitsune::System

  type_coder_hash = {
    INTEGER => ~[CODE, INTEGER],
    STRING => ~[CODE, STRING],
    LIST_N => ~[CODE, LIST_N],
    ~[WRITE, STD_OUT] => ~[CODE, [WRITE, STD_OUT]],
  }

  def initialize(system)
    @system = system
  end

  command CODE do |node|
    edge = @system.execute ~[READ, EDGE], node

    throw "Node `#{node}` is not an edge" unless edge

    type, node = edge.values_at 'head', 'tail'

    # Read Value
    read_systems = @system.execute ~[LIST_V, [NODE, RELATION]], {node: type, type: ~[SYSTEM, READ] }
    read_system = read_systems[0]
    value = @system.execute read_system, node

    # Run value through coder
    coder = type_coder_hash[type]
    throw "Could not find coder for type: #{type}" unless coder

    @system.execute coder, value
  end

  command ~[CODE, [WRITE, STD_OUT]] do |code|
    "puts #{code}"
  end
end
