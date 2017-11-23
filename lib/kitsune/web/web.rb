require 'json'
require 'rack'

using Kitsune::Refine

module Kitsune::Web

  class App
    def initialize(core)
      @core = core
    end

    def call(env)
      # INPUT & VALIDATION
      req = Rack::Request.new env

      # Validate chain
      chain = parts(req.path_info) || []
      return [400, {}, ['Path must consist of node ids in hexadecimal format']] unless chain.all? { |x| x.match? /^[a-f0-9]+$/ }

      # RESOLVE and EXECUTE
      body = req.body.read.strip
      result = body.size > 0 ? JSON.parse(body) : nil

      until chain.empty?
        system_id = chain.pop.from_hex

        system = @core.resolve system_id
        return [400, {}, ["Could not resolve system for id: #{system_id.to_hex}"]] unless system

        result = system.call result
      end

      # OUTPUT
      res = Rack::Response.new(result || JSON.unparse(nil))
      res['Content-Type'] = 'text/html; charset=utf-8'

      res.finish
    end

    def parts(path_info)
      path_info.split('/')[1..-1]
    end
  end

end
