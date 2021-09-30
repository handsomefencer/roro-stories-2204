# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  let(:case_builder) { AdventureCaseBuilder.new }

  describe '#build_itineraries' do
    let(:itineraries) { case_builder.build_itineraries(stack_path) }
    let(:paths)   { [] }

    context 'when stack is a story must return empty' do
      When(:stack) { 'story' }
      Then { assert_empty itineraries }
    end

    context 'when stack is inflection' do
      When(:stack) { 'stacks' }
      Then { assert_empty itineraries }
    end

    context 'when stack has two inflections' do
      When(:stack) { 'stack/stack' }
      Then { assert_equal 4, itineraries.size }
    end

    context 'when has nested inflections' do
      When(:stack) { 'stack' }
      Then { assert_equal 12, itineraries.size }
    end
  end
end
