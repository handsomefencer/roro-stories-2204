# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 okonomi -> 3 postgres -> 2 7_0 -> 1 importmap -> 2 sidekiq' do
  Given(:workbench) {}
  
  Given do 
    rollon(__dir__) 
  end 
end
