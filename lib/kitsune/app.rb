require 'json'

using Kitsune::Refine

class Kitsune::App
  include Kitsune::Nodes

  @@commands = {}
  def self.command(node, &block)
    @@commands[node] = block
  end

  command RANDOM_NODE_ID do
    Random.new.bytes 32
  end

  command TO_JSON do |input|
    input.to_json
  end

  command TO_HEX do |input|
    input.to_hex
  end

  command FROM_HEX do |input|
    input.from_hex
  end

  command ~[RUBY, CODER] do |system|
    templates = {}
    templates[HELLO_WORLD] = <<~EOF
      puts 'Hello World'
    EOF

    templates[system]
  end

  command ~[ECMA_SCRIPT, CODER] do |system|
    templates = {}
    templates[HELLO_WORLD] = <<~EOF
      console.log('Hello World');
    EOF

    templates[system]
  end

  command ~[C, CODER] do |system|
    templates = {}
    templates[HELLO_WORLD] = <<~EOF
      #include "stdio.h"

      int main() {
        char* msg = "Hello World";
        printf("%s%s", msg, "\\n");

        return 0;
      }
    EOF

    templates[system]
  end

  command ~[JAVA, CODER] do |system|
    templates = {}
    templates[HELLO_WORLD] = <<~EOF
      public class App {
          public static void main(String[] args) {
              System.out.println("Hello World");
          }
      }
    EOF

    templates[system]
  end

  def initialize(graph, strings)
    @graph = graph
    @strings = strings

    @system_cache = {}
  end

  def resolve(system_id)
    return @system_cache[system_id] if @system_cache.has_key? system_id

    # Search for system in graph
    system = if @graph.command ~[HAS, [SUPPORTED, COMMAND]], system_id
      proc { |input| @graph.command system_id, input }
    end

    system ||= if @strings.command ~[HAS, [SUPPORTED, COMMAND]], system_id
      proc { |input| @strings.command system_id, input }
    end

    # # Search for system in graph
    # edge = @graph.command ~[READ, EDGE], system_id
    # if edge
    #   system_builder_node = edge['head']
    #   system_node = edge['tail']
    #
    #   system_builder = resolve system_builder_node
    #   system = system_builder.call system_node
    # end

    # Manual system implementations
    system ||= @@commands[system_id]

    @system_cache[system_id] = system
  end

end
