# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureWriter < Thor
      include Thor::Actions
      include Utilities

      attr_reader :itinerary, :stack, :manifest

      no_commands do

        def write(buildenv, storyfile)
          @env = buildenv[:env]
          @env[:force] = true
          actions = buildenv[:actions] || []
          raise read_yaml(storyfile)[:actions].to_s
          actions = actions & read_yaml(storyfile)[:actions]
          unless actions.nil?
            self.source_paths << "#{stack_parent_path(storyfile)}/templates"
            actions.each do |a|
              eval a
            end
          end
        end

        def interpolated_stack_path
          "#{@env[:stack]}/#{@env[:story]}"
        end

        def interpolated_story_name
          "#{@env[:story]}"
        end
      end
    end
  end
end
