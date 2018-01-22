module Kitsune::Systems
  prefix = 'kitsune/systems'

  autoload :NameSystem, "#{prefix}/name_system"
  autoload :RelationSystem, "#{prefix}/relation_system"
  autoload :SQLite3EdgeSystem, "#{prefix}/sqlite3_edge_system"
  autoload :StringSystem, "#{prefix}/string_system"
  autoload :SuperSystem, "#{prefix}/super_system"
end
