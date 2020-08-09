module Roro

  class CLI < Thor

    no_commands do

      def rollon_as_roro
        if Dir['./*'].empty?
          raise Roro::Error.new("Oops -- Roro can't roll itself onto a Rails app if it doesn't exist. Please either change into a directory with a Rails app or generate a new one using '$ roro greenfield'.")
        end
        if ask('Configure $stdout.sync for docker?', choices).eql?('y')
          config_std_out_true
        end
        if ask('Configure .gitignore for roro?', choices).eql?('y')
          gitignore_sensitive_files
        end
        if ask('Add RoRo to your Gemfile?', choices).eql?('y')
          insert_roro_gem_into_gemfile
        end
        if ask('Add handsome_fencer-test to your Gemfile?', choices).eql?('y')
          insert_hfci_gem_into_gemfile
        end
        if ask("Backup 'config/database.yml'?").eql?('y')
          FileUtils.mv 'config/database.yml', "config/database.yml.backup"
        end
        copy_base_files
      end
    end
  end
end