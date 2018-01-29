using Kitsune::Refine

class Kitsune::Systems::IntegerSystem
  include Kitsune::Nodes
  include Kitsune::System

  command ~[WRITE, INTEGER] do |integer|
    integer.to_s(16).rjust(32, '0')
  end

  command ~[READ, INTEGER] do |integer_node|
    integer_node.to_i(16)
  end
end
