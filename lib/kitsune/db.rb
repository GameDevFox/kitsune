require 'sqlite3'

module Kitsune::DB
  def self.new(sqlite3_file = nil)
    file = sqlite3_file || ENV['KITSUNE_SQLITE3_FILE'] || ':memory:'
    puts "Kitsune SQLite3 database file: #{file}"

    SQLite3::Database.new file
  end
end
