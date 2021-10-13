# frozen_string_literal: true

Dir["#{Dir.pwd}/lib/roro/crypto/**/*.rb"].each { |f| require_relative f }

module Roro
  module Crypto
    include FileReflection
    class Cipher; end
    class QuestionAsker < Thor; end
    class CatalogBuilder; end


  end
end
