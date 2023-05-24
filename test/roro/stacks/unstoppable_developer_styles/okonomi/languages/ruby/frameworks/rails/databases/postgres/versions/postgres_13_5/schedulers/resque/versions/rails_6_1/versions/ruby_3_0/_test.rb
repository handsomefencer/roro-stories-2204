# frozen_string_literal: true

require 'test_helper'

describe 'unstoppable_developer_styles: okonomi & languages: ruby
& frameworks: rails & databases: postgres & versions: postgres_13_5
& schedulers: resque & versions: rails_6_1 & versions: ruby_3_0' do
  Given(:workbench) {}

  Given do
    @rollon_dummies = false
    quiet { rollon(__dir__) }
  end

  describe 'must generate a' do
    describe 'Gemfile with the correct' do
      Given(:file) { 'Gemfile' }

      describe 'ruby version' do
        Then  { assert_file file, /ruby ['"]3.0.6['"]/ }
      end

      describe 'rails version' do
        Then  { assert_file file, /gem ['"]rails['"], ['"]~> 6.1.7/ }
      end

      describe 'database gem and version' do
        Then  { assert_file file, /gem ['"]pg['"], ['"]~> 1.1['"]/ }
      end
    end

    describe 'Dockerfile' do
      describe 'ruby version' do
        Then  { assert_file 'Dockerfile', /FROM ruby:3.0-alpine/ }
      end

      describe 'bundler version' do
        Then   { assert_file 'Dockerfile', /gem install bundler:2.2.28/ }
      end

      describe 'database package' do
        Then   { assert_file 'Dockerfile', /postgresql-dev/ }
      end

      describe 'yarn install command' do
        Then   { assert_file 'Dockerfile', /RUN yarn install/ }
      end
    end

    describe 'docker-compose.yml' do
      Given(:file) { 'docker-compose.yml' }

      describe 'volumes' do
        Then { assert_file file, /\nvolumes:/ }
        And  { assert_file file, /\n\s\sdb_data:/ }
        And  { assert_file file, /\n\s\sgem_cache:/ }
        And  { assert_file file, /\n\s\snode_modules:/ }
      end

      describe 'services' do
        describe 'app' do
          describe 'depends_on' do
            Then  { assert_file file, /\n\s\s\s\sdepends_on:/ }
            Then  { assert_file file, /\n\s\s\s\s\s\s- db/ }
          end

          describe 'volumes' do
            Then  { assert_file file, /\n\s\s\s\svolumes:/ }
            Then  { assert_file file, %r{\n\s\s\s\s\s\s- db_data:/var/lib} }
          end
        end

        describe 'database' do
          Then { assert_file file, /\s\sdb:/ }

          describe 'image' do
            Then  { assert_file file, /image: postgres:13.5/ }
          end
        end
      end
    end

    describe 'rails master key config' do
      Given(:file) { 'config/environments/production.rb' }
      Then { assert_file file, /# config.require_master_key = true/ }
    end

    describe 'entrypoints/docker-entrypoint.sh' do
      Given(:file) { 'entrypoints/docker-entrypoint.sh' }

      describe 'must exist' do
        Then  { assert_file file }
      end

      describe 'must have correct permissions' do
        Then  { assert File.owned?(file) }
      end
    end
  end
end