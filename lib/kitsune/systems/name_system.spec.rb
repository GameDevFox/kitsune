require_relative '../spec_helper'

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
      @name_node = @name.execute ~[ADD, NAME], { name: 'name', node: NODE }
    end

    it 'should be able to add names to a dictionary' do
      result = @name.execute ~[LIST_V, [NODE, NAME]], NODE
      expect(result).to eq ['name']
    end

    it 'should be able to remove names from a dictionary' do
      @name.execute ~[REMOVE, NAME], @name_node

      result = @name.execute ~[LIST_V, [NODE, NAME]], NODE
      expect(result).to eq []
    end

    context 'list' do
      before(:each) do
        @name.execute ~[ADD, NAME], { name: 'name one', node: ALPHA }
        @name.execute ~[ADD, NAME], { name: 'name two', node: ALPHA }
        @name.execute ~[ADD, NAME], { name: 'name three', node: ALPHA }

        @name.execute ~[ADD, NAME], { name: 'name four', node: BETA }
        @name.execute ~[ADD, NAME], { name: 'name two', node: BETA }

        @name.execute ~[ADD, NAME], { name: 'another name', node: ALPHA }
        @name.execute ~[ADD, NAME], { name: 'some other name', node: BETA }
      end

      it 'should be able to list the names for a node' do
        my_names = @name.execute ~[LIST_V, [NODE, NAME]], ALPHA
        expect(my_names).to contain_exactly 'name one', 'name two', 'name three', 'another name'

        your_names = @name.execute ~[LIST_V, [NODE, NAME]], BETA
        expect(your_names).to contain_exactly 'name two', 'name four', 'some other name'
      end

      it 'should be able to list the nodes for a name' do
        nodes = @name.execute ~[LIST_V, [NAME, NODE]], 'name one'
        expect(nodes).to contain_exactly ALPHA

        nodes = @name.execute ~[LIST_V, [NAME, NODE]], 'name two'
        expect(nodes).to contain_exactly ALPHA, BETA

        nodes = @name.execute ~[LIST_V, [NAME, NODE]], 'name four'
        expect(nodes).to contain_exactly BETA
      end
    end
  end

end
