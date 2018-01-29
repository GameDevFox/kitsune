require 'json'

using Kitsune::Refine

class Kitsune::Misc
  include Kitsune::Nodes
  include Kitsune::System

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

  command ~[CODE, RUBY] do |system|
    templates = {}
    templates[HELLO_WORLD] = <<~EOF
      puts 'Hello World'
    EOF

    templates[system]
  end

  command ~[CODE, ECMA_SCRIPT] do |system|
    templates = {}
    templates[HELLO_WORLD] = <<~EOF
      console.log('Hello World');
    EOF

    templates[system]
  end

  command ~[CODE, C] do |system|
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

  command ~[CODE, JAVA] do |system|
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
