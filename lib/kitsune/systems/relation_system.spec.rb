require_relative '../spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Systems::RelationSystem do
    before(:each) do
      db = SQLite3::Database.new ':memory:'

      @graph = Kitsune::Systems::SQLite3EdgeSystem.new db
      @relation = Kitsune::Systems::RelationSystem.new @graph
    end

    it 'should be able to write relations' do
      result = @relation.execute ~[WRITE, RELATION], { head: ALPHA, tail: BETA, type: DELTA }
      expect(result).to eq ~[DELTA, [ALPHA, BETA]]

      result = @graph.execute ~[LIST_V, EDGE]
      expect(result.size).to be 2
      expect(result.any? { |edge| edge['head'] == ALPHA && edge['tail'] == BETA }).to be true
      expect(result.any? { |edge| edge['head'] == DELTA && edge['tail'] == ~[ALPHA, BETA] }).to be true
    end

    it 'should be able to delete relations' do
      relation = @relation.execute ~[WRITE, RELATION], { head: ALPHA, tail: BETA, type: DELTA }
      result = @graph.execute ~[LIST_V, EDGE]
      expect(result.size).to be 2

      @relation.execute ~[DELETE, RELATION], relation
      result = @graph.execute ~[LIST_V, EDGE]
      expect(result.size).to be 0
    end

    def writeRelations
      @relation.execute ~[WRITE, RELATION], { head: ALPHA, type: BETA, tail: DELTA }
      @relation.execute ~[WRITE, RELATION], { head: ALPHA, type: BETA, tail: THETA }
      @relation.execute ~[WRITE, RELATION], { head: ALPHA, type: OMEGA, tail: RANDOM }

      @relation.execute ~[WRITE, RELATION], { head: BETA, type: DELTA, tail: THETA }
      @relation.execute ~[WRITE, RELATION], { head: BETA, type: ALPHA, tail: RANDOM }
      @relation.execute ~[WRITE, RELATION], { head: BETA, type: ALPHA, tail: OMEGA }
      @relation.execute ~[WRITE, RELATION], { head: DELTA, type: ALPHA, tail: OMEGA }
    end

    it 'should be able to list node relations' do
      writeRelations

      result = @relation.execute ~[LIST_V, [NODE, RELATION]], {node: ALPHA, type: BETA }
      expect(result).to contain_exactly DELTA, THETA

      result = @relation.execute ~[LIST_V, [NODE, RELATION]], {node: ALPHA, type: OMEGA }
      expect(result).to contain_exactly RANDOM

      result = @relation.execute ~[LIST_V, [NODE, RELATION]], {node: BETA, type: DELTA }
      expect(result).to contain_exactly THETA

      result = @relation.execute ~[LIST_V, [NODE, RELATION]], {node: BETA, type: ALPHA }
      expect(result).to contain_exactly OMEGA, RANDOM
    end

    it 'should be able to list relation nodes' do
      writeRelations

      result = @relation.execute ~[LIST_V, [RELATION, NODE]], {node: DELTA, type: BETA }
      expect(result).to contain_exactly ALPHA

      result = @relation.execute ~[LIST_V, [RELATION, NODE]], {node: THETA, type: BETA }
      expect(result).to contain_exactly ALPHA

      result = @relation.execute ~[LIST_V, [RELATION, NODE]], {node: RANDOM, type: OMEGA }
      expect(result).to contain_exactly ALPHA

      result = @relation.execute ~[LIST_V, [RELATION, NODE]], {node: THETA, type: DELTA }
      expect(result).to contain_exactly BETA

      result = @relation.execute ~[LIST_V, [RELATION, NODE]], {node: RANDOM, type: ALPHA }
      expect(result).to contain_exactly BETA

      result = @relation.execute ~[LIST_V, [RELATION, NODE]], {node: OMEGA, type: ALPHA }
      expect(result).to contain_exactly BETA, DELTA
    end
  end

end
