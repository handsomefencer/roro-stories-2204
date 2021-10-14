# frozen_string_literal: true

require 'test_helper'

describe Configurator do
  let(:options) { {} }
  let(:config)  { Configurator.new(options) }

  context 'without options' do
    describe '#initialize' do
      Then { assert_match 'developer_styles', config.stack }
      And  { assert_equal Hash, config.structure.class }
    end

    describe '#validate_stack' do
      Then { assert_nil config.validate_stack }
    end

    describe '#choose_adventure' do
      context 'when fatsufodo' do
        context 'when django' do
          Given { stub_journey(%w[1 1]) }
          Given { config.choose_adventure }
          Then  { assert_file_match_in 'stories/django', config.itinerary }
        end

        context 'when wordpress' do
          Given { stub_journey(%w[1 4]) }
          Given { config.choose_adventure }
          Then  { assert_file_match_in 'stories/wordpress', config.itinerary }
        end

        context 'when rails' do
          Given { stub_journey(%w[1 3]) }
          Given { config.choose_adventure }
          Then  { assert_file_match_in 'stories/rails', config.itinerary }
        end
      end
    end
  end

  context 'when stack path' do
    let(:options) { { stack: stack_path } }

    Given { stub_journey(%w[1 1 1]) }
    Given { config.choose_adventure }

    describe '#initialize' do
      Then { assert_match 'stack/valid', config.stack }
    end

    describe '#validate_stack' do
      Then { assert_nil config.validate_stack }
    end

    describe '#choose_adventure' do
      Then { assert config.choose_adventure }
    end

    describe '#itinerary' do
      let(:itinerary) { %w[
          stack/stack/plots/story1
          stack/stack/stories/story1
          stack/stacks/stacks_1/stack_2
          stack/with_one_inflection/plots/story ] }

      Then  { itinerary.each { |s| assert_file_match_in s, config.itinerary } }
    end

    describe '#manifest' do
      let(:manifest) { %w[
        valid/stack/stack.yml
        valid/stack/stack/story.yml
        valid/stack/stack/plots/story1/story1.yml
        valid/stack/stack/stories/story1/story1.yml
        valid/stack/stack/story/story.yml
        valid/stack/stacks/stacks_1/stack_2/stack_2.yml
        valid/stack/story/story.yml
        valid/stack/with_one_inflection/with_one_inflection.yml
        valid/stack/with_one_inflection/plots/story/story.yml
      ] }

      Then { manifest.each { |s| assert_file_match_in s, config.manifest } }
    end

    describe '#build_graph()' do
      let(:graph_value) { config.env[:base][:somekey][:value] }

      context 'when answers env default' do
        Given { stub_answers_env }
        Given { config.build_env }
        Then  { assert_equal 'somevalue', graph_value }
      end

      context 'when answers env overridden' do
        Given { stub_answers_env('newvalue') }
        Given { config.build_env }
        Then  { assert_equal 'newvalue', graph_value }
      end
    end
  end
end