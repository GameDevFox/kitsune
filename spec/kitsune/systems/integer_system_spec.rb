require 'spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Systems::IntegerSystem do
    before(:each) do
      @system = Kitsune::Systems::IntegerSystem.new
    end

    it 'should write an integer' do
      integer_node = @system.command ~[WRITE, INTEGER], 12345
      expect(integer_node).to eql '00000000000000000000000000003039'
    end

    it 'should read an integer' do
      integer = @system.command ~[READ, INTEGER], '00000000000000000000000000010932'
      expect(integer).to be 67890
    end
  end
end
