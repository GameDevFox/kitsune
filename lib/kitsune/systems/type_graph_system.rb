using Kitsune::Refine

class Kitsune::Systems::TypeGraphSystem
  include Kitsune::Nodes
  include Kitsune::System

  TYPE_DATA_SYSTEM = ~[SYSTEM, [GRAPH, TYPE]]
  READ_SYSTEM = ~[SYSTEM, READ]

  type_read_system_map = {
      EDGE => ~[READ, EDGE],
      STRING => ~[READ, STRING],
      INTEGER => ~[READ, INTEGER],
      GROUP => ~[READ, GROUP],
      LIST_N => ~[READ, LIST_N],

      ~[WRITE, STD_OUT] => CODE
  }

  def initialize(system)
    @system = system
  end

  command INIT do
    init_edge = @system.execute ~[READ, EDGE], ~[TYPE_DATA_SYSTEM, IS_INITIALIZED]
    unless init_edge
      type_read_system_map.each { |type, read_system|
        @system.execute ~[WRITE, RELATION], { head: type, type: READ_SYSTEM, tail: read_system }
      }
    end
  end
end
