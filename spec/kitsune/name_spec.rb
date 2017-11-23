require 'spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Name::System do
    before(:each) do
      # Setup
      db = SQLite3::Database.new ':memory:'
      Kitsune::Graph::SQLite3Graph.init db
      Kitsune::String::System.init db

      @system = Kitsune::CompositeSystem.new

      @system << Kitsune::Graph::SQLite3Graph.new(db)
      @system << Kitsune::String::System.new(db)
      @system << Kitsune::Graph::Relation::System.new(@system)

      @name = Kitsune::Name::System.new(@system, MAIN_DICT)
      @dict_node = @name.command ~[ADD, NAME], { name: 'name', node: NODE }
    end

    it 'should be able to add names to a dictionary' do
      result = @name.command ~[LIST, [NODE, NAME]], NODE
      expect(result).to eq ['name']
    end

    it 'should be able to remove names from a dictionary' do
      @name.command ~[REMOVE, NAME], @dict_node

      result = @name.command ~[LIST, [NODE, NAME]], NODE
      expect(result).to eq []
    end

    context 'list' do
      before(:each) do
        @name.command ~[ADD, NAME], { name: 'name one', node: ~'my node' }
        @name.command ~[ADD, NAME], { name: 'name two', node: ~'my node' }
        @name.command ~[ADD, NAME], { name: 'name three', node: ~'my node' }

        @name.command ~[ADD, NAME], { name: 'name four', node: ~'your node' }
        @name.command ~[ADD, NAME], { name: 'name two', node: ~'your node' }

        @name.command ~[ADD, NAME], { name: 'another name', node: ~'my node' }
        @name.command ~[ADD, NAME], { name: 'some other name', node: ~'your node' }
        
        # intentional interference
        @other_name = Kitsune::Name::System.new(@system, ~'other dict')

        @other_name.command ~[ADD, NAME], { name: 'other name one', node: ~'my node' }
        @other_name.command ~[ADD, NAME], { name: 'name two', node: ~'other my node' }
        @other_name.command ~[ADD, NAME], { name: 'name three', node: ~'my node' }

        @other_name.command ~[ADD, NAME], { name: 'other name four', node: ~'your node' }
        @other_name.command ~[ADD, NAME], { name: 'name two', node: ~'other your node' }

        @other_name.command ~[ADD, NAME], { name: 'yet another name', node: ~'my node' }
        @other_name.command ~[ADD, NAME], { name: 'and some other name', node: ~'your node' }
      end

      it 'should be able to list the names for a node' do
        my_names = @name.command ~[LIST, [NODE, NAME]], ~'my node'
        expect(my_names).to contain_exactly('name one', 'name two', 'name three', 'another name')

        your_names = @name.command ~[LIST, [NODE, NAME]], ~'your node'
        expect(your_names).to contain_exactly('name two', 'name four', 'some other name')
      end

      it 'should be able to list the nodes for a name' do
        nodes = @name.command ~[LIST, [NAME, NODE]], 'name one'
        expect(nodes).to eq [~'my node']

        nodes = @name.command ~[LIST, [NAME, NODE]], 'name two'
        expect(nodes).to contain_exactly(~'my node', ~'your node')

        nodes = @name.command ~[LIST, [NAME, NODE]], 'name four'
        expect(nodes).to eq [~'your node']
      end
    end
  end

end
