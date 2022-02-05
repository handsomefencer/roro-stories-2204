# frozen_string_literal: true

require 'test_helper'

describe 'adventure::django::0 python-v3_10_1' do
  Given(:workbench) { }

  Given { @rollon_loud    = true }
  Given { @rollon_dummies = true }
  Given { rollon(__dir__) }
  
  describe 'directory must contain' do
    describe 'docker-compose.yml with' do
      Given(:file) { 'docker-compose.yml' }

      describe 'correct docker-compose version' do
        Then { assert_file file, /version: '3.9'/ }
      end

      describe 'correct services' do
        describe 'db' do
          Then { assert_includes read_yaml(file)[:services].keys, :db  }
          And  { assert_includes read_yaml(file)[:services].keys, :web  }
        end
      end
    end

    describe 'Dockerfile' do
      Given(:file) { 'Dockerfile' }

      describe 'must have content' do
        describe 'matching' do
          describe 'steps' do
            Then { assert_file file, /# syntax=docker/ }
          end

          describe 'steps' do
            Then { assert_file file, /\nFROM python:3/ }
            And  { assert_file file, /\nRUN pip install -r requirements.txt/ }
          end

          describe 'polished' do
            # Then { assert_file file, /\nrequirements.txt/ }
            Then { refute File.exist?('polisher') }
          end
        end
      end
    end

    describe 'docker-compose.yml' do
      Given(:file) { 'docker-compose.yml' }

      describe 'must have content' do 
        describe 'matching' do
          Then { assert_file file, /version: '3.9'/ }
        end
      end
    end
  end
end
