# frozen_string_literal: true

require 'test_helper'

describe 'unstoppable_developer_styles: okonomi & languages: ruby & frameworks: rails & databases: postgres & versions: postgres_14_1 & schedulers: sidekiq & versions: rails_7_1 & versions: ruby_3_0' do
  Given(:workbench) {}

  Given do
    @rollon_dummies = true
    rollon(__dir__)
  end

  describe 'must have a' do
    describe 'docker entrypoint' do
      Then { assert_file 'entrypoints/docker-entrypoint.sh' }
    end

    describe 'config/database.yml' do
      Given(:file) { 'config/database.yml' }
      describe 'with postgres docker' do
        Then { assert_file file, /<%= ENV\.fetch\('DATABASE_HOST'\)/ }
      end
    end

    describe 'mise-en-place' do
      Then { assert_file 'mise/env/base.env' }
    end

    describe 'Gemfile with the correct' do
      describe 'rails version' do
        focus
        Then { assert_file 'Gemfile', /gem "rails", "~> 7.0.4/ }
      end

      describe 'db' do
        Then { assert_file 'Gemfile', /gem ["']pg["'], ["']~> 1.1/ }
      end
    end

    describe 'Dockerfile' do
      # focus
      Given(:file) { 'Dockerfile' }
      describe 'ruby version' do
        Then { assert_file file, /FROM ruby:3.0/ }
      end

      describe 'bundler version' do
        Then { assert_file file, /bundler:2.2.28/ }
      end

      describe 'alpine db packages' do
        describe 'postgresql' do
          Then { assert_file file, /postgresql-dev/ }
        end

        describe 'node' do
          Then { assert_file file, /nodejs/ }
        end

        describe 'node' do
          Then { assert_file file, /RUN yarn install/ }
        end
      end
    end

    describe 'docker-compose.yml' do
      Given(:file) { 'docker-compose.yml' }

      describe 'volumes' do
        Then { assert_file file, /\nvolumes:\n\s\sdb_data/ }
        And  { assert_file file, /\s\sgem_cache/ }
        And  { assert_file file, /\s\snode_modules/ }
      end

      describe 'database service' do
        describe 'database service' do
          Then { assert_file file, /\n\s\sdb:/ }

          describe 'image' do
            Then { assert_file file, /\n\s\s\s\simage: postgres:14.1/ }
          end
        end
      end
    end
  end
end