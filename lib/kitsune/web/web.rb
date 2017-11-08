require 'rack'

module Kitsune
  module Web

    class App
      def initialize(core)
        @core = core
      end

      def call(env)
        # INPUT & VALIDATION
        req = Rack::Request.new env

        chain = parts req.path_info
        command_id = chain.shift

        # Validate command_id
        return [400, {}, ['Nope...']] unless command_id.match? /^[a-f0-9]+$/

        # RESOLVE
        command = @core.resolve command_id.from_hex
        return [400, {}, ["Could not resolve system for id: #{command_id}"]] unless command

        # BUILD INPUT
        # TODO: Make this more flexible and run off of the system
        last_arg = chain.pop
        result = @core.resolve(last_arg) || last_arg

        until chain.empty?
          system_id = chain.pop

          system = @core.resolve system_id
          return [400, {}, ["Could not resolve system for id: #{system_id}"]] unless system

          result = system.call result
        end

        # EXECUTE
        result = command.call result

        # OUTPUT
        res = Rack::Response.new result
        res['Content-Type'] = 'text/html; charset=utf-8'

        res.finish
      end

      def parts(path_info)
        path_info.split('/')[1..-1]
      end
    end
  end
end
