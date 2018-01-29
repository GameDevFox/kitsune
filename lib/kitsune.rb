module Kitsune
  prefix = 'kitsune'

  # modules
  autoload :Coders, "#{prefix}/coders"
  autoload :Graph, "#{prefix}/graph"
  autoload :Systems, "#{prefix}/systems"

  # classes
  autoload :App, "#{prefix}/app"
  autoload :Builder, "#{prefix}/builder"
  autoload :Hash, "#{prefix}/hash"
  autoload :Misc, "#{prefix}/misc"
  autoload :Nodes, "#{prefix}/nodes"
  autoload :RackApp, "#{prefix}/rack_app"
  autoload :Refine, "#{prefix}/refine"
  autoload :System, "#{prefix}/system"
  autoload :Util, "#{prefix}/util"
  autoload :Version, "#{prefix}/version"
end
