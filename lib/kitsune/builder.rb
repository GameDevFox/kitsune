require 'sqlite3'

using Kitsune::Refine

module Kitsune::Builder
  include Kitsune::Nodes

  def self.build_db
    file = ENV['KITSUNE_SQLITE3_FILE'] || ':memory:'
    puts "Kitsune SQLite3 database file: #{file}"

    SQLite3::Database.new file
  end

  def self.build_system(db = nil)
    db ||= build_db

    system = Kitsune::Systems::SuperSystem.new

    system << Kitsune::Systems::SQLite3EdgeSystem.new(db, debug: true)
    system << Kitsune::Systems::StringSystem.new(db, true)
    system << Kitsune::Systems::IntegerSystem.new

    system << Kitsune::Systems::RelationSystem.new(system)
    system << Kitsune::Systems::NameSystem.new(system)

    system << Kitsune::Misc.new

    system
  end

  def self.build(system = nil)
    system ||= build_system

    # TODO: Move this to a system and configure it for logging
    puts ''
    Kitsune::Nodes.constants.each { |const|
      name = const.to_s.downcase
      node = Kitsune::Nodes.const_get const
      puts "#{name} => #{node}"
      system.command ~[WRITE, NAME], { node: node, name: name }
    }
    puts ''

    Kitsune::App.new system
  end
end
