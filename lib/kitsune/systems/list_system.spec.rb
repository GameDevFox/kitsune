require_relative '../spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Systems::ListSystem do
    before(:each) do
      db = SQLite3::Database.new ':memory:'
      graph = Kitsune::Systems::SQLite3EdgeSystem.new db

      @system = Kitsune::Systems::ListSystem.new graph

      @list_node = @system.execute ~[WRITE, LIST_N], [ALPHA, BETA, DELTA, OMEGA]
      @list_node_b = @system.execute ~[WRITE, LIST_N], [DELTA, THETA]
    end

    it 'should write an list' do
      expect(@list_node).to eql '80847a4ba4a3c429602139ad02cfab6dded83a9c3ee24dcc9198452e64c65b4e'
      expect(@list_node_b).to eql '4a5dd0653e57c1c2395e5f9cb68766b02aa350be30376e41078b0fbc9a7153e4'
    end

    it 'should read an list' do
      list = @system.execute ~[READ, LIST_N], @list_node
      expect(list).to eq [ALPHA, BETA, DELTA, OMEGA]

      list_b = @system.execute ~[READ, LIST_N], @list_node_b
      expect(list_b).to eq [DELTA, THETA]
    end
  end
end
