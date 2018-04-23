require_relative './spec_helper'

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
      it 'should be able to hash arrays by type' do
        expect([NODE, EDGE] ** :edge).to eq '15058e274e041418ad58f9a98b7febe9280490ccc658cae5e837ebf8e07b69dd'
        expect([NODE, EDGE, GROUP, CHAIN] ** :group).to eq '666cf542e6ffc3ee65fa06d3c29d1dd80a77ce925939780cd6e2e886c344c3c9'
        expect([NODE, EDGE, GROUP, CHAIN] ** :list).to eq '83996fcb66fee58e8480a012940f32b98071813942f0d0139bf4b72ed38e3de0'
      end

      it 'should be able to hexify' do
        result = ['one', ['two', 'three', ['four', 'five', 'six']]].hexify
        expect(result).to eq ['6f6e65', ['74776f', '7468726565', ['666f7572', '66697665', '736978']]]
      end
    end

    context Hash do
      it 'should be able to hexify' do
        result = { one: 'two', three: { four: 'five', six: 'seven', eight: { nine: 'ten', eleven: 12, thirteen: 14 } } }.hexify
        expect(result).to eq({ one: '74776f', three:  { four: '66697665', six: '736576656e', eight: { nine: '74656e', eleven: 12, thirteen: 14 } } })
      end
    end
  end

end
