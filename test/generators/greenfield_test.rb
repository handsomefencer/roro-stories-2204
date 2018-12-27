require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

  Given(:prepare) {
    prepare_destination
    Dir.chdir 'greenfield'
  }

  describe "prepare" do

    Given { prepare }

    Then { Dir.pwd.split('roro').last.must_equal "/tmp/greenfield" }
    And { Dir.empty?(Dir.pwd).must_equal true}
  end

  describe "usage" do

    Given { prepare }
    Given { subject.greenfield }

    generated_files = %w( Gemfile docker-compose.yml Dockerfile Gemfile.lock)
    generated_files.each do |generated_file|

      describe "must generate #{generated_file}" do

        Then do

          assert_file generated_file
        end
      end
    end
  end
end
