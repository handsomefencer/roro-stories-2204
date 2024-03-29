# frozen_string_literal: true

module Roro
  # Where all the generation, configuration, greenfielding happens.
  class CLI < Thor
    desc 'generate:containers', 'Generate containers.'
    map 'generate:containers' => 'generate_containers'
    method_options :containers => :array
    def generate_containers(*containers)
      mise = Roro::CLI.mise
      containers = options['containers'] || (containers.empty? ? %w[frontend backend database] : containers)
      create_file("#{mise}/scripts/.keep")

      containers.each { |s| s.split('/').last }.each do |container|
        create_file("#{mise}/containers/#{container}/scripts/.keep")
        create_file("#{mise}/containers/#{container}/env/.keep")
      end
    end
  end
end
