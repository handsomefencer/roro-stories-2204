# frozen_string_literal: true

require 'test_helper'

describe '1 -> 1 -> 1: database: postgres, rails version: 6.1' do
  Given(:workbench) {}

  Given do
    @rollon_dummies = false
    rollon(__dir__)
  end

  describe 'must have directory' do
    Given(:directory) { '' }
    Then { assert_directory directory }

    describe 'with file' do
      Given(:file) { "#{directory}/expected/file.name" }

      Then { assert_file file }

      describe 'with content' do
        Given(:content) { /expected content string/ }

        Then { assert_file file, content }
      end
    end
  end
end