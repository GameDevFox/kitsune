require_relative '../spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Systems::BooleanSystem do
    before(:each) do
      @system = Kitsune::Systems::BooleanSystem.new
    end

    it 'should write an boolean' do
      boolean_node = @system.execute ~[WRITE, BOOLEAN], true
      expect(boolean_node).to eql TRUE

      boolean_node = @system.execute ~[WRITE, BOOLEAN], false
      expect(boolean_node).to eql FALSE
    end

    it 'should read an boolean' do
      boolean = @system.execute ~[READ, BOOLEAN], TRUE
      expect(boolean).to be true

      boolean = @system.execute ~[READ, BOOLEAN], FALSE
      expect(boolean).to be false
    end
  end
end
