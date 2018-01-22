require 'spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Systems::NameSystem do
    before(:each) do
      # Setup
      db = SQLite3::Database.new ':memory:'

      @system = Kitsune::Systems::SuperSystem.new

      @system << Kitsune::Systems::SQLite3EdgeSystem.new(db)
      @system << Kitsune::Systems::StringSystem.new(db)
      @system << Kitsune::Systems::RelationSystem.new(@system)

      @name = Kitsune::Systems::NameSystem.new(@system)
      @name_node = @name.command ~[ADD, NAME], { name: 'name', node: NODE }
    end

    it 'should be able to add names to a dictionary' do
      result = @name.command ~[LIST, [NODE, NAME]], NODE
      expect(result).to eq ['name']
    end

    it 'should be able to remove names from a dictionary' do
      @name.command ~[REMOVE, NAME], @name_node

      result = @name.command ~[LIST, [NODE, NAME]], NODE
      expect(result).to eq []
    end

    context 'list' do
      before(:each) do
        @name.command ~[ADD, NAME], { name: 'name one', node: ALPHA }
        @name.command ~[ADD, NAME], { name: 'name two', node: ALPHA }
        @name.command ~[ADD, NAME], { name: 'name three', node: ALPHA }

        @name.command ~[ADD, NAME], { name: 'name four', node: BETA }
        @name.command ~[ADD, NAME], { name: 'name two', node: BETA }

        @name.command ~[ADD, NAME], { name: 'another name', node: ALPHA }
        @name.command ~[ADD, NAME], { name: 'some other name', node: BETA }
      end

      it 'should be able to list the names for a node' do
        my_names = @name.command ~[LIST, [NODE, NAME]], ALPHA
        expect(my_names).to contain_exactly 'name one', 'name two', 'name three', 'another name'

        your_names = @name.command ~[LIST, [NODE, NAME]], BETA
        expect(your_names).to contain_exactly 'name two', 'name four', 'some other name'
      end

      it 'should be able to list the nodes for a name' do
        nodes = @name.command ~[LIST, [NAME, NODE]], 'name one'
        expect(nodes).to contain_exactly ALPHA

        nodes = @name.command ~[LIST, [NAME, NODE]], 'name two'
        expect(nodes).to contain_exactly ALPHA, BETA

        nodes = @name.command ~[LIST, [NAME, NODE]], 'name four'
        expect(nodes).to contain_exactly BETA
      end
    end
  end

end
