# frozen_string_literal: true

require_relative 'validations'

module Roro
  module Configurators
    class StructureBuilder < Thor
      attr_reader :structure

      def initialize(override_location = nil)
        build_story
        @structure.merge(read_yaml(override_location)) if override_location
      end

      def build_story
        @structure = {
          actions: [''],
          env: {
            base: {},
            development: {},
            staging: {},
            production: {}
          },
          preface: '',
          questions: [
            {
              question: '',
              help: '',
              action: ''
            }
          ]
        }
      end
    end
  end
end
