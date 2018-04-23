require 'json'
require 'rack'

using Kitsune::Refine

class Kitsune::RackApp
  include Kitsune::Nodes

  def initialize(system = nil)
    @system = system || Kitsune.new
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

    chain.reverse.each { |system|
      supports_command = @system.execute ~[HAS, [SUPPORTED, COMMAND]], system
      throw [400, {}, ["Could not resolve system for id: #{system}"]] unless supports_command

      result = @system.execute system, result
    }

    # OUTPUT
    res = Rack::Response.new(JSON.unparse(result))
    res['Content-Type'] = 'text/html; charset=utf-8'

    res.finish
  end

  def parts(path_info)
    path_info.split('/')[1..-1]
  end
end
