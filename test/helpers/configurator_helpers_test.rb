# frozen_string_literal: true

require 'test_helper'

describe 'Roro::Test::Helpers::Configurator' do
  describe '.stubs_journey' do
    Given(:args) { [:okonomi, :ruby, :rails, :v7_0] }
    # Then { assert_equal [3,2,1,2], journey_choices(*args) }
  end

  describe '.stack_path' do
    context 'when valid and when' do
      context 'not defined' do
        Then { assert_match 'valid', stack_path }
        And  { refute_match 'valid/', stack_path }
      end

      context 'defined' do
        When(:stack) { 'defined' }
        Then { assert_match 'valid/defined', stack_path }
        And  { refute_match 'valid/defined/', stack_path }
      end
    end

    context 'when invalid and when' do
      context 'not defined' do
        Then { assert_match 'invalid', stack_path(:invalid) }
        And  { refute_match 'invalid/', stack_path(:invalid) }
      end

      context 'defined' do
        When(:stack) { 'defined' }
        Then { assert_match 'invalid/defined', stack_path(:invalid) }
        And  { refute_match 'invalid/defined/', stack_path(:invalid) }
      end
    end
  end
end