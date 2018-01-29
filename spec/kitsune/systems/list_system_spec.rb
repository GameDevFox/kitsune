require 'spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Systems::ListSystem do
    before(:each) do
      db = SQLite3::Database.new ':memory:'
      graph = Kitsune::Systems::SQLite3EdgeSystem.new db

      @system = Kitsune::Systems::ListSystem.new graph

      @list_node = @system.command ~[WRITE, LIST], [ALPHA, BETA, DELTA, OMEGA]
      @list_node_b = @system.command ~[WRITE, LIST], [DELTA, THETA]
    end

    it 'should write an list' do
      expect(@list_node).to eql 'c8945cce57ae580e96e59cca8116f70558860f6685c7dd391a562cce3934d9b2'
      expect(@list_node_b).to eql '5f3a2d3fa1910bb9f9a5cc143d008e20b412edd5a8347fb94c62a85aa3e1c4f1'
    end

    it 'should read an list' do
      list = @system.command ~[READ, LIST], @list_node
      expect(list).to eq [ALPHA, BETA, DELTA, OMEGA]

      list_b = @system.command ~[READ, LIST], @list_node_b
      expect(list_b).to eq [DELTA, THETA]
    end
  end
end
