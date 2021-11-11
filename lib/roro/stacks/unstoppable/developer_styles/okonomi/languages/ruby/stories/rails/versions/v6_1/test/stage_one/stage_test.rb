require 'test_helper'

describe 'okonomi ruby rails 7_0' do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:adventures) { %w[ okonomi ruby rails v6_1 ] }
  Given(:overrides)  { %w[] }

  Given(:rollon)    {
    copy_stage_dummy(__dir__)
    stubs_dependencies_met?
    stubs_yes?
    stubs_adventure
    stub_overrides
    stub_run_actions
    cli.rollon
  }

  Given { quiet { rollon } }

  describe 'must generate a' do
    describe 'Dockerfile' do
      describe 'ruby version' do
        Then  { assert_file 'Dockerfile', /FROM ruby:2.7.4-alpine/ }
      end

      describe 'yarn install command' do
        Then   { assert_file 'Dockerfile', /RUN yarn install/ }
      end
    end
  end
end