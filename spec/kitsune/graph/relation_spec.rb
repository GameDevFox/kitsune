require 'spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Graph::Relation do
    before(:each) do
      db = SQLite3::Database.new ':memory:'
      Kitsune::Graph::SQLite3Graph.init db

      @graph = Kitsune::Graph::SQLite3Graph.new db
      @relation = Kitsune::Graph::Relation::System.new @graph
    end

    it 'should be able to write relations' do
      result = @relation.command ~[WRITE, RELATION], { head: 'alpha', tail: 'beta', type: 'delta' }
      expect(result).to eq ~['delta', ['alpha', 'beta']]

      result = @graph.command ~[LIST, EDGE]
      expect(result.size).to be 2
      expect(result.any? { |edge| edge['head'] == 'alpha' && edge['tail'] == 'beta' }).to be true
      expect(result.any? { |edge| edge['head'] == 'delta' && edge['tail'] == ~['alpha', 'beta'] }).to be true
    end

    it 'should be able to delete relations' do
      relation = @relation.command ~[WRITE, RELATION], { head: 'alpha', tail: 'beta', type: 'delta' }
      result = @graph.command ~[LIST, EDGE]
      expect(result.size).to be 2

      @relation.command ~[DELETE, RELATION], relation
      result = @graph.command ~[LIST, EDGE]
      expect(result.size).to be 0
    end

    context 'search' do
      before(:each) do
        @relation.command ~[WRITE, RELATION], { head: 'my-name', tail: 'alpha', type: 'name' }
        @relation.command ~[WRITE, RELATION], { head: 'another-name', tail: 'alpha', type: 'name' }
        @relation.command ~[WRITE, RELATION], { head: 'your-name', tail: 'beta', type: 'name' }
        @relation.command ~[WRITE, RELATION], { head: 'another-name', tail: 'beta', type: 'name' }
        @relation.command ~[WRITE, RELATION], { head: 'another-name', tail: 'delta', type: 'name' }
        @relation.command ~[WRITE, RELATION], { head: 'alpha', tail: 'beta', type: 'parent' }
        @relation.command ~[WRITE, RELATION], { head: 'alpha', tail: 'delta', type: 'parent' }
      end

      it 'should be able to search node relations' do
        nodes = @relation.command ~[SEARCH, RELATION], { head: 'my-name', type: 'name' }
        expect(nodes.tails).to eq ['alpha']

        nodes = @relation.command ~[SEARCH, RELATION], { head: 'another-name', type: 'name' }
        expect(nodes.tails).to contain_exactly('alpha', 'beta', 'delta')

        nodes = @relation.command ~[SEARCH, RELATION], { head: 'alpha', type: 'parent' }
        expect(nodes.tails).to contain_exactly('beta', 'delta')
      end

      it 'should be able to read relation nodes' do
        relations = @relation.command ~[SEARCH, RELATION], { tail: 'alpha', type: 'name' }
        expect(relations.heads).to contain_exactly('my-name', 'another-name')

        relations = @relation.command ~[SEARCH, RELATION], { tail: 'beta', type: 'name' }
        expect(relations.heads).to contain_exactly('your-name', 'another-name')

        relations = @relation.command ~[SEARCH, RELATION], { tail: 'delta', type: 'parent' }
        expect(relations.heads).to eq ['alpha']
      end
    end
  end

end
