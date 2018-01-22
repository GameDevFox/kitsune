require 'spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Systems::SuperSystem do
    nil_system = (Class.new do
      include Kitsune::System
    end).new

    string_system = (Class.new do
      include Kitsune::System
      command 'test' do
        'hello'
      end
    end).new

    array_system_a = (Class.new do
      include Kitsune::System
      command 'test' do
        [1, 2, 3]
      end

      command 'one more' do
        'nothing'
      end
    end).new

    array_system_b = (Class.new do
      include Kitsune::System
      command 'test' do
        [7, 8, 9]
      end

      command 'another one' do
        'something'
      end
    end).new

    it 'should return the first result if result is not array' do
      sys = Kitsune::Systems::SuperSystem.new
      sys.systems = [nil_system, string_system, nil_system]

      result = sys.command 'test'

      expect(result).to eq 'hello'
    end

    it 'should concatenate results if results are arrays' do
      sys = Kitsune::Systems::SuperSystem.new
      sys << nil_system
      sys << array_system_a
      sys << nil_system
      sys << array_system_b

      result = sys.command 'test'

      expect(result).to eq [1, 2, 3, 7, 8, 9]
    end

    it 'should throw an exception if mixed result types are returned' do
      sys = Kitsune::Systems::SuperSystem.new [array_system_a, nil_system, string_system]

      expect {
        sys.command 'test'
      }.to raise_error TypeError
    end

    it 'should implement it\'s own version of HAS_SUPPORTED_COMMAND' do
      sys = Kitsune::Systems::SuperSystem.new [nil_system, string_system, array_system_a, array_system_b]

      expect(sys.command ~[HAS, [SUPPORTED, COMMAND]], 'test').to be true
      expect(sys.command ~[HAS, [SUPPORTED, COMMAND]], 'one more').to be true
      expect(sys.command ~[HAS, [SUPPORTED, COMMAND]], 'another one').to be true
      expect(sys.command ~[HAS, [SUPPORTED, COMMAND]], 'not this').to be false
    end
  end

end
