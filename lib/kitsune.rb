module Kitsune
  prefix = 'kitsune'

  autoload :Coders, "#{prefix}/coders"
  autoload :Graph, "#{prefix}/graph"
  autoload :Systems, "#{prefix}/systems"

  autoload :DB, "#{prefix}/db"
  autoload :Hash, "#{prefix}/hash"
  autoload :Misc, "#{prefix}/misc"
  autoload :Nodes, "#{prefix}/nodes"
  autoload :RackApp, "#{prefix}/rack_app"
  autoload :Refine, "#{prefix}/refine"
  autoload :System, "#{prefix}/system"
  autoload :Util, "#{prefix}/util"
  autoload :Version, "#{prefix}/version"

  def self.new(system = nil)
    system ||= Kitsune::Systems::build
    Kitsune::Nodes.name_nodes system
    system
  end
end
