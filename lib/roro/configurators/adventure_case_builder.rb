# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder

      attr_reader :cases, :itineraries, :matrix

      def initialize(stack=nil)
        @stack = stack || Roro::CLI.stacks
        @cases =  {}
        @matrix = []
        build_cases
      end

      def build_cases(stack = nil, cases = {})
        stack ||= @stack
        case
        when stack_type(stack).eql?(:templates)
          return
        when stack_type(stack_parent_path(stack)).eql?(:inflection) && [:stack, :story].include?(stack_type(stack))
          cases[name(stack).to_sym] = {}
          cases = cases[name(stack).to_sym]
        end
        children(stack).each do |c|
          build_cases(c, cases)
        end
        @cases = cases
      end

      def document_cases
        File.open("#{Dir.pwd}/test/helpers/adventure_cases.yml", "w") do |f|
          f.write(cases.to_yaml)
        end
        workflow = "#{Dir.pwd}/.circleci/src/workflows/test-matrix-rollon.yml"
        hash = read_yaml("#{workflow}")
        hash[:jobs][0][:"test-rollon"][:matrix][:parameters][:answers] = matrix_cases
        File.open(workflow, "w") { |f| f.write(hash.to_yaml) }

      end

      def case_from_path(stack, array = nil)
        array ||= stack.split("#{@stack}/").last.split('/') unless @case
        folder = array.shift
        stack = "#{@case ? stack : @stack}/#{folder}"
        (@case ||= [])
        @case << folder if stack_is_adventure?(stack)
        case_from_path(stack, array) unless array.empty?
        @case
      end

      def matrix_cases(array = [], d = 0, hash = cases)
        # (@matri/x ||= [])
        hash.each do |k, v|
          array = (array.take(d) << hash.keys.index(k) + 1)
          v.empty? ? @matrix << array : matrix_cases(array, d+1, v)
        end
        @matrix
      end
    end
  end
end
