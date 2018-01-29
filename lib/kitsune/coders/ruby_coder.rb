using Kitsune::Refine

class Kitsune::Coders::RubyCoder
  include Kitsune::Nodes
  include Kitsune::System

  type_coder_hash = {
      STRING => ~[CODE, STRING],
      INTEGER => ~[CODE, INTEGER],
      ~[WRITE, STD_OUT] => ~[CODE, [WRITE, STD_OUT]],
      LIST => ~[CODE, LIST]
  }

  def initialize(system)
    @system = system
  end

  command CODE do |node|
    edge = @system.command ~[READ, EDGE], node

    throw "Node `#{node}` is not an edge" unless edge

    type, node = edge.values_at 'head', 'tail'

    # Read Value
    read_systems = @system.command ~[LIST, [NODE, RELATION]], { node: type, type: ~[SYSTEM, READ] }
    read_system = read_systems[0]
    value = @system.command read_system, node

    # Run value through coder
    coder = type_coder_hash[type]
    throw "Could not find coder for type: #{type}" unless coder

    @system.command coder, value
  end

  command ~[CODE, STRING] do |string|
    escaped_string = string.gsub("\\", "\\\\\\").gsub('"', '\"')
    "\"" + escaped_string + "\""
  end

  command ~[CODE, INTEGER] do |integer|
    integer.to_s
  end

  command ~[CODE, [WRITE, STD_OUT]] do |code|
    "puts #{code}"
  end

  command ~[CODE, LIST] do |list|
    code_list = list.map { |item| @system.command CODE, item }
    code_list.join("\n")
  end
end
