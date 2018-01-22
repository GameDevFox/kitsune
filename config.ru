#!/usr/bin/env ruby
require 'bundler/setup'

require 'rack/cors'
require 'kitsune'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end

app = Kitsune::Builder.build
rack_app = Kitsune::RackApp.new app

run rack_app
