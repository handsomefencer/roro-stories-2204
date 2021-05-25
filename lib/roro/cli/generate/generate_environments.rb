# frozen_string_literal: true

module Roro

  # Where all the generation, configuration, greenfielding happens.
  class CLI < Thor
    desc 'generate::environments', 'Generate environment files and keys'
    map 'generate::environments' => 'generate_environments'
    map 'generate:environments'  => 'generate_environments'

    def generate_environments(*environments)
      exposer = Roro::Crypto::Exposer.new
      exposer.expose(environments, './roro', '.env.enc')
    end
  end
end
