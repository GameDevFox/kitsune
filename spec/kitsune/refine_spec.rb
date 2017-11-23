require 'spec_helper'

using Kitsune::Refine

module Kitsune::Nodes

  RSpec.describe Kitsune::Refine do
    context String do
      it 'String can be parsed to hex' do
        expect('hello'.to_hex).to eql '68656c6c6f'
      end

      it 'String can be parsed from hex' do
        expect('676f6f64627965'.from_hex).to eql 'goodbye'
      end
    end

    context Array do
      it 'Should be able to hash arrays by type' do
        expect(([NODE, EDGE] ** :edge).to_hex).to eq '15058e274e041418ad58f9a98b7febe9280490ccc658cae5e837ebf8e07b69dd'
        expect(([NODE, EDGE, GROUP, CHAIN] ** :group).to_hex).to eq '666cf542e6ffc3ee65fa06d3c29d1dd80a77ce925939780cd6e2e886c344c3c9'
        expect(([NODE, EDGE, GROUP, CHAIN] ** :list).to_hex).to eq '8796ebacff0bcd4a519fb64a54eca78825245e04076e6546b5f63c0e6ddd5935'
      end
    end
  end

end
