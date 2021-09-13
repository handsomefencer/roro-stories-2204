# frozen_string_literal: true

require 'test_helper'

describe AdventureChooser do
  let(:catalog_root)     { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog_path)     { "#{catalog_root}/#{catalog}" }
  let(:adventure)        { AdventureChooser.new(catalog_path) }
  let(:catalog)    { 'roro' }

  context 'when catalog has no inflections' do
    let(:catalog) { 'roro/roro' }

    Then { assert_equal 1, adventure.itinerary.size }
    And  { assert adventure.itinerary.grep(/roro.yml/).any? }
  end

  def question_faker(array)
    array.map do |item|
      inflection_path = "#{catalog_path}/#{item[0]}"
      builder = QuestionBuilder.new(inflection: inflection_path)

      [builder.question, item[1]]
    end
  end

  context 'when plot choice is' do
    let(:inflections) { [] }

    context 'php' do
      Given { inflections << %w[plots 2] }
      Given { assert_inflections(inflections) }
      Then  { assert adventure.itinerary.grep(/php.yml/).any? }
    end

    context 'ruby when story is' do
      Given { inflections << %w[plots 4] }

      context 'ruby_gem' do
        Given { inflections << %w[plots/ruby/stories 2] }
        Given { assert_inflections(inflections) }
        Then  { assert adventure.itinerary.grep(/ruby_gem.yml/).any? }
      end

      context 'rails when' do
        Given { inflections << %w[plots/ruby/stories 1] }
        Given { inflections << %w[plots/ruby/stories/rails/flavors 2] }
        Given { inflections << %w[plots/ruby/stories/rails/databases 1] }

        context 'flavor is rails_vue' do
          Given { assert_inflections(inflections) }
          Then  { assert adventure.itinerary.grep(/rails_react.yml/).any? }
        end

        context 'database is mysql' do
          Given { assert_inflections(inflections) }
          Then  { assert adventure.itinerary.grep(/mysql.yml/).any? }
        end
      end
    end
  end
end
