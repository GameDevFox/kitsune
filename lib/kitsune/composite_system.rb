require 'forwardable'

using Kitsune::Refine

class Kitsune::CompositeSystem
  extend Forwardable
  include Kitsune::System

  attr_accessor :systems
  def_delegator :@systems, :<<

  def initialize(systems = [])
    @systems = systems
  end

  def command(node, input = nil)
    self_command = self.class.commands[node]
    return self.instance_exec input, &self_command if self_command

    not_found = true

    result = nil
    @systems.each do |system|
      next unless system.command ~[HAS, [SUPPORTED, COMMAND]], node

      not_found = false
      this_result = system.command node, input

      if result.class == Array
        result += this_result
      else
        result = this_result
        break unless result.class == Array
      end
    end

    throw "Command #{node.inspect} is not supported by this system" if not_found

    result
  end

  command ~[HAS, [SUPPORTED, COMMAND]] do |command|
    @systems.any? { |system| system.command ~[HAS, [SUPPORTED, COMMAND]], command }
  end
end
