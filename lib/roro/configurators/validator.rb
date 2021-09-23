# frozen_string_literal: true

module Roro
  module Configurators
    class Validator

      def initialize(catalog = nil, structure = nil)
        @catalog   = catalog   || Roro::CLI.catalog_root
        @structure = structure || StructureBuilder.build
        @error     = Roro::CatalogError
        @permitted_extensions = %w[yml yaml]
        validate_catalog(@catalog)
      end

      def validate_catalog(catalog)
        case
        when catalog_not_present?(catalog)
          @msg = 'Catalog not present'
        when catalog_is_story_file?(catalog)
          validate_story(catalog)
        when catalog_is_template?(catalog)
          return
        when catalog_is_empty?(catalog)
          @msg = 'Catalog cannot be an empty folder'
        else
          get_children(catalog).each { |child| validate_catalog(child) }
        end
        raise(@error, "#{@msg} in #{catalog}") if @msg
      end

      def validate_story(story = nil )
        @error = Roro::CatalogError
        case
        when story_is_dotfile?(story)
          return
        when has_unpermitted_extension?(story)
          @msg = 'Catalog has unpermitted extension'
        when story_is_empty?
          @msg = 'Story file is empty'
        else
          validate_story_content(@content, @structure)
        end
      end

      def validate_story_content(content, story)
        case
        when content.is_a?(NilClass)
          @msg = 'Story contains a nil value'
        when !content.is_a?(story.class)
          @msg = "'#{content}' must be an instance of #{story.class}"
        when content.is_a?(Array)
          validate_story_array(content, story)
        when content.is_a?(Hash)
          validate_story_hash(content, story)
        end
      end

      def validate_story_array(content, story)
        if content.any?(nil)
          @msg = 'Story contains an empty array'
        else
          content.each { |item| validate_story_content(item, story[0]) }
        end
      end

      def validate_story_hash(content, story)
        case
        when story_has_unpermitted_keys?(content, story)
          @msg = "#{@unpermitted} not in permitted keys: #{@permitted}"
        when story_has_nil_value?(content)
          @msg = "Value for :#{content.key(nil)} must not be nil"
        when story&.keys&.any?
          content.each { |k, v| validate_story_content(v, story[k]) }
        end
      end

      def story_has_unpermitted_keys?(content, story)
        @permitted = story&.keys
        @unpermitted = content.keys - @permitted
        @permitted.any? && @unpermitted.any?
      end

      def story_has_nil_value?(content)
        content&.values&.include?(nil)
      end
    end
  end
end
