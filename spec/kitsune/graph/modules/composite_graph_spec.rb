require 'spec_helper'

RSpec.describe Kitsune::Graph::CompositeGraph do

  it 'should return a merged set of nodes' do
    class ModA
      def travel(node, path)
        %w(a b)
      end
    end

    class ModB
      def travel(node, path)
        [1, 2, 3]
      end
    end

    class ModC
      def travel(node, path)
        %w(a list of words)
      end
    end

    graphs = [ModA.new, ModB.new, ModC.new]
    graph = Kitsune::Graph::CompositeGraph.new *graphs
    nodes = graph.travel('node', 'path')

    expect(nodes).to eql ['a', 'b', 1, 2, 3, 'a', 'list', 'of', 'words']
  end
end
