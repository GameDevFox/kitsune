#!/usr/bin/env ruby

require 'bundler/setup'

require 'kitsune'
require 'sqlite3'

file = ENV['KITSUNE_SQLITE3_FILE'] || ':memory:'

db = SQLite3::Database.new file
edges = Kitsune::Graph::SQLite3Edges.new db

core = Kitsune::App.new edges
run Kitsune::Web::App.new core
