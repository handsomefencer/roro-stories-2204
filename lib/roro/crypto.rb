require "openssl"
require "base64"
module Roro::Crypto

  class << self

    def generate_key
      @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
      @salt = '8 octets'
      @new_key = @cipher.random_key
      Base64.encode64(@new_key)
    end

    def generate_keys(environments, directory, extension)
    end

    def obfuscate(environments, directory, extension)
    end

    # def generate_keys(environments = args.first ? [args.first] : gather_environments
    #   check_for_environments(environments)
    #   environments.each do |environment|
    #     confirm_overwrite_key?(environment)
    #     confirm_files_decrypted?(environment)
    #     create_file "roro/keys/#{environment}.key", encoded_key
    #   end 
    # end 
       
    def write_to_file(data, filename)
      if File.exist?(filename)
        raise DataDestructionError, "#{filename} exists. Please remove it and try again."
      else
        File.open(filename, "w") { |io| io.write data }
      end
    end

    def write_key_to_file(target_directory, key_name)
      filename = [target_directory, "/", key_name, ".key"].join
      write_to_file(generate_key, filename)
    end

    def gather_environments(*args)
      directory = args.first
      extensions = args.last
      
      environments = []
      extensions.each do |extension|
        Roro::Crypto.source_files(nil, extension).each do |env_file|
          environments << env_file.split('/').last.split('.').first
        end
      end
      environments.uniq
    end

    def source_files(directory=nil, extension=nil)
      directory ||= './roro'
      unless directory.split('/')[1].eql?('roro')
        raise SourceDirectoryError, "Can only obfuscate and expose files in './roro/'."
      end
      Dir.glob(directory + "/**/*#{extension}")
    end

    def build_cipher(environment)
      @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
      @salt = '8 octets'
      @pass_phrase = get_key(environment)
      @cipher.encrypt.pkcs5_keyivgen @pass_phrase, @salt
    end

    def encrypt(file, environment=nil)
      environment ||= file.split('/').last.split('.').first
      build_cipher(environment)
      encrypted = @cipher.update(File.read file) + @cipher.final
      write_to_file(Base64.encode64(encrypted), file + '.enc')
    end

    def decrypt(file, environment=nil)
      environment ||= file.split('.')[-3].split('/').last
      build_cipher(environment)
      encrypted = Base64.decode64 File.read(file)
      @cipher.decrypt.pkcs5_keyivgen @pass_phrase, @salt
      decrypted = @cipher.update(encrypted) + @cipher.final
      decrypted_file = file.split('.enc').first
      write_to_file decrypted, decrypted_file
    end

    def obfuscate(env=nil, dir=nil, ext=nil)
      ext = ext || "#{env}*.env"
      source_files(dir, ext).each do |file|
        encrypt(file, env)
      end
    end

    def expose(env=nil, dir=nil, ext=nil)
      ext = ext || "#{env}.env.enc"
      source_files(dir, ext).each do |file|
        decrypt(file, env)
      end
    end

    def get_key(environment, directory='roro')
      env_key = environment.upcase + '_KEY'
      key_file = Dir.glob("roro/keys/#{environment}.key").first
      case
      when ENV[env_key].nil? && key_file.nil?
        raise KeyError, "No #{env_key} set. Please set one as a variable or in a file."
      when ENV[env_key]
        ENV[env_key]
      when File.exist?(key_file)
        File.read(key_file).strip
      end
    end
  end
end