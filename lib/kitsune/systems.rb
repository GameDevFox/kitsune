module Kitsune::Systems
  prefix = 'kitsune/systems'

  autoload :BooleanSystem, "#{prefix}/boolean_system"
  autoload :GroupSystem, "#{prefix}/group_system"
  autoload :IntegerSystem, "#{prefix}/integer_system"
  autoload :ListSystem, "#{prefix}/list_system"
  autoload :NameSystem, "#{prefix}/name_system"
  autoload :RelationSystem, "#{prefix}/relation_system"
  autoload :SQLite3EdgeSystem, "#{prefix}/sqlite3_edge_system"
  autoload :StringSystem, "#{prefix}/string_system"
  autoload :SuperSystem, "#{prefix}/super_system"
  autoload :TypeGraphSystem, "#{prefix}/type_graph_system"

  def self.build(db = nil)
    db ||= Kitsune::DB.new

    system = Kitsune::Systems::SuperSystem.new

    system << Kitsune::Systems::SQLite3EdgeSystem.new(db, debug: true)
    system << Kitsune::Systems::StringSystem.new(db, true)
    system << Kitsune::Systems::IntegerSystem.new

    system << Kitsune::Systems::RelationSystem.new(system)
    system << Kitsune::Systems::NameSystem.new(system)

    system << Kitsune::Misc.new

    system
  end
end
