# frozen_string_literal: true

require_relative '../shared_test'

describe '1 -> 3 -> 2: database: sqlite, rails version: 7.0' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Invariant { assert_1_3_tests }

  describe 'Gemfile with the correct rails version' do
    Then { assert_file 'Gemfile', /gem ["']rails["'], ["']~> 7.0.5/ }
  end
end
