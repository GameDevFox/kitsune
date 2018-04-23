using Kitsune::Refine

module Kitsune::System
  include Kitsune::Nodes

  def self.included(base)
    base.instance_variable_set :@procs, {}
    base.extend(ClassMethods)

    base.class_eval {
      command ~[LIST_V, [SUPPORTED, COMMAND]] do
        self.class.commands.keys
      end

      command ~[HAS, [SUPPORTED, COMMAND]] do |input|
        self.class.commands.has_key? input
      end
    }
  end

  def execute(node, input = nil)
    block = self.class.commands[node]
    throw "Command #{node.inspect} is not supported by this system" unless block

    self.instance_exec input, &block
  end

  module ClassMethods
    def commands
      @procs
    end

    def command(node, &block)
      commands[node] = block
    end
  end

end
