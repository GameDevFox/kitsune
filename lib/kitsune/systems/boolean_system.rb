using Kitsune::Refine

class Kitsune::Systems::BooleanSystem
  include Kitsune::Nodes
  include Kitsune::System

  command ~[WRITE, BOOLEAN] do |boolean|
    boolean ? TRUE : FALSE
  end

  command ~[READ, BOOLEAN] do |boolean_node|
    boolean_node == TRUE
  end
end
