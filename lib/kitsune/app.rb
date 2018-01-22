using Kitsune::Refine

class Kitsune::App
  include Kitsune::Nodes
  include Kitsune::System

  attr_reader :system

  def initialize(system)
    @system = system
    @system_cache = {}
  end

  def resolve(system_id)
    return @system_cache[system_id] if @system_cache.has_key? system_id

    # Resolve command from self
    system = if command ~[HAS, [SUPPORTED, COMMAND]], system_id
      proc { |input| command system_id, input }
    end

    # Resolve command from system
    system ||= if @system.command ~[HAS, [SUPPORTED, COMMAND]], system_id
      proc { |input| @system.command system_id, input }
    end

    # # Resolve command from graph
    # edge = @graph.command ~[READ, EDGE], system_id
    # if edge
    #   system_builder_node = edge['head']
    #   system_node = edge['tail']
    #
    #   system_builder = resolve system_builder_node
    #   system = system_builder.call system_node
    # end

    @system_cache[system_id] = system
  end
end
