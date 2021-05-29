# frozen_string_literal: true

module Roro
  class CLI < Thor

    desc 'generate::obfuscated', 'Encrypts .smart.env files for safe storage.'
    map 'generate::obfuscated' => 'generate_obfuscated'
    map 'generate:obfuscated'  => 'generate_obfuscated'

    def generate_obfuscated(*environments)
      obfuscator = Roro::Crypto::Obfuscator.new
      obfuscator.obfuscate(environments, './roro', '.env')
    end
  end
end
