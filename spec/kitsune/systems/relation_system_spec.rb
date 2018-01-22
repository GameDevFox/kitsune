require 'spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Systems::RelationSystem do
    before(:each) do
      db = SQLite3::Database.new ':memory:'

      @graph = Kitsune::Systems::SQLite3EdgeSystem.new db
      @relation = Kitsune::Systems::RelationSystem.new @graph
    end

    it 'should be able to write relations' do
      result = @relation.command ~[WRITE, RELATION], { head: ALPHA, tail: BETA, type: DELTA }
      expect(result).to eq ~[DELTA, [ALPHA, BETA]]

      result = @graph.command ~[LIST, EDGE]
      expect(result.size).to be 2
      expect(result.any? { |edge| edge['head'] == ALPHA && edge['tail'] == BETA }).to be true
      expect(result.any? { |edge| edge['head'] == DELTA && edge['tail'] == ~[ALPHA, BETA] }).to be true
    end

    it 'should be able to delete relations' do
      relation = @relation.command ~[WRITE, RELATION], { head: ALPHA, tail: BETA, type: DELTA }
      result = @graph.command ~[LIST, EDGE]
      expect(result.size).to be 2

      @relation.command ~[DELETE, RELATION], relation
      result = @graph.command ~[LIST, EDGE]
      expect(result.size).to be 0
    end

    def writeRelations
      @relation.command ~[WRITE, RELATION], { head: ALPHA, type: BETA, tail: DELTA }
      @relation.command ~[WRITE, RELATION], { head: ALPHA, type: BETA, tail: THETA }
      @relation.command ~[WRITE, RELATION], { head: ALPHA, type: OMEGA, tail: RANDOM }

      @relation.command ~[WRITE, RELATION], { head: BETA, type: DELTA, tail: THETA }
      @relation.command ~[WRITE, RELATION], { head: BETA, type: ALPHA, tail: RANDOM }
      @relation.command ~[WRITE, RELATION], { head: BETA, type: ALPHA, tail: OMEGA }
      @relation.command ~[WRITE, RELATION], { head: DELTA, type: ALPHA, tail: OMEGA }
    end

    it 'should be able to list node relations' do
      writeRelations

      result = @relation.command ~[LIST, [NODE, RELATION]], { node: ALPHA, type: BETA }
      expect(result).to contain_exactly DELTA, THETA

      result = @relation.command ~[LIST, [NODE, RELATION]], { node: ALPHA, type: OMEGA }
      expect(result).to contain_exactly RANDOM

      result = @relation.command ~[LIST, [NODE, RELATION]], { node: BETA, type: DELTA }
      expect(result).to contain_exactly THETA

      result = @relation.command ~[LIST, [NODE, RELATION]], { node: BETA, type: ALPHA }
      expect(result).to contain_exactly OMEGA, RANDOM
    end

    it 'should be able to list relation nodes' do
      writeRelations

      result = @relation.command ~[LIST, [RELATION, NODE]], { node: DELTA, type: BETA }
      expect(result).to contain_exactly ALPHA

      result = @relation.command ~[LIST, [RELATION, NODE]], { node: THETA, type: BETA }
      expect(result).to contain_exactly ALPHA

      result = @relation.command ~[LIST, [RELATION, NODE]], { node: RANDOM, type: OMEGA }
      expect(result).to contain_exactly ALPHA

      result = @relation.command ~[LIST, [RELATION, NODE]], { node: THETA, type: DELTA }
      expect(result).to contain_exactly BETA

      result = @relation.command ~[LIST, [RELATION, NODE]], { node: RANDOM, type: ALPHA }
      expect(result).to contain_exactly BETA

      result = @relation.command ~[LIST, [RELATION, NODE]], { node: OMEGA, type: ALPHA }
      expect(result).to contain_exactly BETA, DELTA
    end
  end

end
