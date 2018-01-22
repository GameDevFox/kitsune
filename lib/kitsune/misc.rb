require 'json'

using Kitsune::Refine

class Kitsune::Misc
  include Kitsune::Nodes
  include Kitsune::System

  def initialize(base)
    @base = base
  end

  # TODO: Clean up
  command NAMED_COMMAND do |input|
    p :here

    command_names = input[0]
    args = input[1]

    proc_chain = command_names.map { |name|
      nodes = @base.command ~[LIST, [NAME, NODE]], name

      throw "No nodes found for name: #{name}" if nodes.size == 0
      throw "More than one node found for name: #{name}" if nodes.size > 1

      system = nodes[0]
      proc = resolve(system)
      throw [400, {}, ["Could not resolve system for id: #{system}"]] unless proc
      proc
    }

    result = args
    proc_chain.each { |proc|
      result = proc.call result
    }

    result
  end

  command ~[READ, EDGE] do |query_result|
    query_result.edges
  end

  command ~[READ, RELATION] do |query_result|
    query_result.type_edges
  end

  command RANDOM_NODE_ID do
    Random.new.bytes(32).to_hex
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

  command HEXIFY do |input|
    input.hexify
  end

  command ~[CODER, RUBY] do |system|
    templates = {}
    templates[HELLO_WORLD] = <<~EOF
      puts 'Hello World'
    EOF

    templates[system]
  end

  command ~[CODER, ECMA_SCRIPT] do |system|
    templates = {}
    templates[HELLO_WORLD] = <<~EOF
      console.log('Hello World');
    EOF

    templates[system]
  end

  command ~[CODER, C] do |system|
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

  command ~[CODER, JAVA] do |system|
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
end
