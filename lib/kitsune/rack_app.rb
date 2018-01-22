require 'json'
require 'rack'

using Kitsune::Refine

class Kitsune::RackApp
  def initialize(core)
    @core = core
  end

  def call(env)
    # INPUT & VALIDATION
    req = Rack::Request.new env

    # Validate chain
    chain = parts(req.path_info) || []
    return [400, {}, ['Path must consist of node ids in hexadecimal format']] unless chain.all? { |x| x.match? /^[a-f0-9]+$/ }

    # Build proc chain
    proc_chain = chain.map { |system|
      proc = @core.resolve system
      throw [400, {}, ["Could not resolve system for id: #{system}"]] unless proc
      proc
    }

    # RESOLVE and EXECUTE
    body = req.body.read.strip
    result = body.size > 0 ? JSON.parse(body) : nil

    proc_chain.each { |proc|
      result = proc.call result
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
