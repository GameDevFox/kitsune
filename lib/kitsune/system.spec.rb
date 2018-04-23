require_relative './spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::System do
    COMMAND_ID = 'command_id'

    SystemClass = Class.new do
      include Kitsune::System

      command COMMAND_ID do
        'result'
      end
    end

    before(:each) do
      @system = SystemClass.new
    end

    it 'should execute commands' do
      result = @system.execute COMMAND_ID
      expect(result).to eq 'result'
    end

    it 'should list supported commands' do
      commands = @system.execute ~[LIST_V, [SUPPORTED, COMMAND]]
      expect(commands).to eq [
        ~[LIST_V, [SUPPORTED, COMMAND]],
        ~[HAS, [SUPPORTED, COMMAND]],
        COMMAND_ID
      ]
    end

    it 'should indicate if command is supported' do
      is_supported = @system.execute ~[HAS, [SUPPORTED, COMMAND]], COMMAND_ID
      expect(is_supported).to be true
    end
  end

end
