require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

  describe 'commands' do
    
    { 
      generate_config: 'generate::config',
      generate_exposed: 'generate::exposed',
      generate_key: 'generate::key',
      generate_keys: 'generate::keys',
      generate_obfuscated: 'generate::obfuscated',
      greenfield_rails: 'greenfield::rails',
      rollon_rails: 'rollon::rails',
       
    }.each do |k,v| 
      describe v do 
        describe 'command must exist' do 

          Then { assert_includes Roro::CLI.commands.keys, k.to_s }  
        end

        describe 'mapping must exist' do 

          Then { assert_includes Roro::CLI.map.keys, v.to_s }  
        end
        
        describe 'mapping to key must be correct' do 

          Then { assert_equal Roro::CLI.map[v], k.to_s }  
        end
      end
    end
  end
end