require 'spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Systems::GroupSystem do
    before(:each) do
      db = SQLite3::Database.new ':memory:'
      graph = Kitsune::Systems::SQLite3EdgeSystem.new db

      @system = Kitsune::Systems::GroupSystem.new graph

      @group_node = @system.command ~[WRITE, GROUP], [DELTA, BETA, ALPHA]
    end

    it 'should write a group' do
      expect(@group_node).to eql '0abd385b2a4d976eea1386c292f3e43d411d068849b685b1c7c6ab0aa9253936'

      group_node_b = @system.command ~[WRITE, GROUP], [DELTA, ALPHA, BETA]
      expect(group_node_b).to eql @group_node
    end

    it 'should read an group' do
      group = @system.command ~[READ, GROUP], @group_node
      expect(group).to contain_exactly ALPHA, BETA, DELTA
    end
  end
end
