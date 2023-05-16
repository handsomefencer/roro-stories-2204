# frozen_string_literal: true

module Roro
  module Configurators
    class Reflector
      include Utilities

      attr_reader :cases, :itineraries, :stack

      def initialize(stack = nil)
        @stack = stack || Roro::CLI.stacks
      end

      def log_to_mise(name, content)
        path = "#{Dir.pwd}/mise/logs/#{name}.yml"
        File.open(path, 'w') { |f| f.write(content.to_yaml) }
      end

      def reflect(stack = nil)
        stack ||= @stack
        reflection = {
          inflections: [],
          stacks: {},
          stories: [],
          picks: []
        }
        array = []
        children(stack).each_with_index do |c, index|
          if [:inflection_stub].include?(stack_type(c))
            array  << { stack_name(c).to_sym => reflect(c) }
          elsif [:inflection].include?(stack_type(c))
            array  << { stack_name(c).to_sym => reflect(c) }
          elsif [:stack].include?(stack_type(c))
            reflection[:stacks][index + 1] = reflection c
          elsif [:story].include?(stack_type(c))
            reflection[:picks] << index + 1
            # story = c.split("#{Roro::CLI.stacks}/").last
          elsif [:storyfile].include?(stack_type(c))
            byebug
            foo = 'bar'
          else

            foo = 'bar' # reflection[:stories] << story
          end
        end
        reflection
      end

      def reflection(stack = nil)
        stack ||= @stack
        reflection = {
          inflections: [],
          stacks: {},
          stories: [],
          picks: []
        }
        children(stack).each_with_index do |c, index|
          if %i[inflection inflection_stub].include?(stack_type(c))
            reflection[:inflections] << { stack_name(c).to_sym => reflection(c) }
          elsif [:stack].include?(stack_type(c))
            reflection[:stacks][index + 1] = reflection c
          elsif [:story].include?(stack_type(c))
            reflection[:picks] << index + 1
            story = c.split("#{Roro::CLI.stacks}/").last
            reflection[:stories] << story
          end
        end
        reflection
      end

      def adventure_cases(stack = @stack, siblings = [], kase = [])
        @kases ||= []
        kase
        siblings
        name = stack.split('/').last
        # byebug if name.eql?('ruby')

        st = stack_type(stack)
        children = children(stack) # .select { |c| %i[stack inflection story].include? stack_type(c) }
        inflections = children.select { |child| stack_type(child).eql?(:inflection) }
        case stack_type(stack)
        when :inflection
          byebug if inflections.count > 0
          # kase << name
          children.each_with_index do |child, index|
            index
            choice = "#{index + 1}: #{child.split('/').last}"
            choice = index + 1
            # byebug if name.eql?('unstoppable_developer_styles')
            # byebug if name.eql?('ruby')
            # byebug if name.eql?('languages')
            # byebug
            adventure_cases(child, siblings.dup, kase.dup << choice) # if index.eql?(0)
          end
        when :stack
          if inflections.count > 1
            # siblings + +
            inflections[1..-1].each { |inflection| siblings << inflection }
            # byebug
          end
          # kase << name
          # inflections = children.select { |child| stack_type(child).eql?(:inflection) }
          # snapshot = []
          # # byebug if inflections.count > 1
          # inflections.each do |_inflection|
          # end
          children.each_with_index do |child, index|
            index
            cname = child.split('/').last

            # byebug if cname.eql?('languages')
            #   snapshot = []
            #   choice = "#{index + 1}: #{child.split('/').last}"
            #   byebug if name.eql?('unstoppable_developer_styles')
            #   # byebug if name.eql?('adventures')
            # byebug if stack_type(child).eql?(:inflection)
            # byebug unless siblings.empty?
            adventure_cases(child, siblings, kase)
          end
        when :story
          # cname = child.split('/').last
          if siblings.empty?
            @kases << kase
          else
            # byebug
            # byebug
            adventure_cases(siblings.shift, siblings, kase)

          end
        else
          children.each do |child|
            cname = child.split('/').last
            # byebug
            name = stack.split('/').last
            # byebug if name.eql?('laravel')
            # byebug if name.eql?('ruby')

            adventure_cases(child, siblings, kase)
          end
        end
        @kases
        # byebug
      end

      def cases(hash = reflection, array = [], matrix = [])
        # byebug if hash.dig(:inflections).size > 1
        hash[:inflections]&.each do |inflection|
          artifact = matrix.dup
          inflection.each do |_k, v|
            # next unless inflection.eql?(hash[:inflections].first)

            cases(v, array, matrix)
            kreateds = matrix - artifact
            next unless hash[:inflections].size > 1

            kreateds.each do |kreated|
              matrix.delete(kreated)
              cases(hash[:inflections].last.values.first, kreated, matrix)
            end
          end
        end
        hash[:stacks]&.each do |k, v|
          cases(v, (array + [k]), matrix)
        end
        hash[:picks]&.each do |k|
          # byebug if array.eql?([1, 3, 1, 1, 1, 1])
          # byebug if (array << k).eql?([1, 3, 1, 1, 1, 1, 1])
          matrix << array + [k]
          # byebug if array.eql?([1, 3, 1, 1, 1, 1, 1])
        end
        matrix
      end

      def stack_itineraries(stack)
        itineraries.select do |itinerary|
          parent = stack.split("#{Roro::CLI.stacks}/").last
          itinerary.any? do |i|
            i.match? parent
          end
        end
      end

      def itinerary_index(itinerary, stack)
        stack_itineraries(stack).index(itinerary)
      end

      def itineraries(hash = reflection, array = [], matrix = [])
        hash[:inflections]&.each do |inflection|
          artifact = matrix.dup
          inflection.each do |_k, v|
            next unless inflection.eql?(hash[:inflections].first)

            itineraries(v, array, matrix)
            kreateds = matrix - artifact
            next unless hash[:inflections].size > 1

            kreateds.each do |kreated|
              matrix.delete(kreated)
              itineraries(hash[:inflections].last.values.first, kreated, matrix)
            end
          end
        end
        hash[:stacks]&.each do |_k, v|
          itineraries(v, array.dup, matrix)
        end
        hash[:stories]&.each do |k, _v|
          matrix << array + [k]
        end
        matrix
      end

      def metadata
        @implicit_tags = %w[git okonomi adventures databases frameworks stories versions]

        data = {}
        data[:adventures] = {}
        itineraries.each_with_index do |itinerary, index|
          data[:adventures][index] = {
            title: adventure_title(itinerary),
            slug: adventure_slug(itinerary),
            canonical_slug: adventure_canonical_slug(itinerary),
            tech_tags: tech_tags(itinerary),
            versioned_tech_tags: versioned_tech_tags(itinerary),
            unversioned_tech_tags: unversioned_tech_tags(itinerary)
          }
        end
        data
      end

      def tech_tags(itinerary)
        tags = []
        itinerary.each do |i|
          path = "#{Roro::CLI.stacks}"
          i.split('/').each do |item|
            path = "#{path}/#{item}"
            tags += stack_stories(path)
                    .map { |s| stack_name(s).split('.yml').first }
                    .reject { |s| s.chr.eql?('_') }
                    .map { |s| append_tech_to_version(s, path) }
          end
        end
        tags.uniq
      end

      def append_tech_to_version(tag, path)
        if stack_parent(path).eql?('versions')
          base = stack_name(stack_parent_path(stack_parent_path(path)))
          "#{base}#{tag.gsub(tag.chr, ':').gsub('_', '.')}"
        else
          tag
        end
      end

      def unversioned_tech_tags(itinerary)
        tech_tags(itinerary).reject do |t|
          t.match?(':')
        end
      end

      def versioned_tech_tags(itinerary)
        tech_tags(itinerary).select do |t|
          t.match?(':')
        end
      end

      def adventure_slug(itinerary)
        array = []
        itinerary.each do |i|
          keyword = i.split('/').last(3) - @implicit_tags
          array << keyword.join('_')
        end
        array.join('-')
      end

      def adventure_title(itinerary)
        versioned_tags = versioned_tech_tags(itinerary)
        redundant = versioned_tags.map { |t| t.split(':').first }
        tags = tech_tags(itinerary) - redundant

        (tags - @implicit_tags).join(' ')
      end

      def adventure_canonical_slug(itinerary)
        array = []
        itinerary.each do |i|
          inflections = %w[adventures databases frameworks stories versions]
          keyword = i.split('/').last(3) - inflections
          array << keyword.join('_')
        end
        array.join('-')
      end
    end
  end
end
