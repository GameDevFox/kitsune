#!/usr/bin/env ruby

require 'bundler/setup'

require 'rack/cors'
require 'sqlite3'

require 'kitsune'

class Rackup
  include Kitsune::Nodes

  def self.db
    # file = ENV['KITSUNE_SQLITE3_FILE']
    # db = SQLite3::Database.new file

    db = SQLite3::Database.new ':memory:' # file

    Kitsune::Graph::SQLite3Graph.init db
    Kitsune::String::System.init db

    db
  end

  def self.app
    edges = Kitsune::Graph::SQLite3Graph.new db
    strings = Kitsune::String::System.new db

    core = Kitsune::App.new edges, strings
    Kitsune::Web::App.new core
  end
end

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end

run Rackup.app
