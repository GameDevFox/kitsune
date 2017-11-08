#!/usr/bin/env ruby

require 'bundler/setup'

require 'kitsune'
require 'sqlite3'

file = ENV['KITSUNE_SQLITE3_FILE']

db = SQLite3::Database.new file
Kitsune::Graph::SQLite3Edges.init db
