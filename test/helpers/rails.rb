module TestHelper
  module Stories 
    module Rails
      
      def rails_test_base 
        stubs_dependency_responses
        stubs_startup_commands
        stubs_system_calls
        @cli = Roro::CLI.new 
      end

      def greenfield_rails_test_base 
        prepare_destination 'greenfield/greenfield'
        stubs_rollon
        rails_test_base
      end
      
      def rollon_rails_test_base 
        prepare_destination 'rails/603'
        rails_test_base
      end 
    end
  end
end