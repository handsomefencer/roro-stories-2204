# frozen_string_literal: true

module Roro

  class CLI < Thor

    desc 'generate:adventure', 'Generate adventure for adventure tests.'
    map 'generate:adventure' => 'generate_adventure'

    method_options :adventure => :string

    def generate_adventure(adventure)
      @env = { adventure_name: adventure.split('/').last }
      location =  "lib/roro/stacks/#{adventure}"
      directory 'adventure', location, @env
      generate_annotations
      # generate_annotations("#{location}/test/0/_test.rb")
    end

    no_commands do
      def adventure_name
        @env[:adventure_name]
      end
    end
  end
end