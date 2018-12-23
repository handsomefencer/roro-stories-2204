require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

  Given { prepare_destination }

  describe "commands" do

    Then { assert_includes Roro::CLI.commands.keys, "greenfield"}
    And  { assert_includes Roro::CLI.commands.keys, "configurate"}
    And  { assert_includes Roro::CLI.commands.keys, "dockerize"}
  end

  describe ":configurate" do

    describe "without argument" do

      Then { subject.configurate['APP_NAME'].must_equal "greenfield_app"}
    end

    describe "with an argument specified" do

      Given { subject.env_vars = {
        'APP_NAME' => "strawberry_field_app",
        'DOCKERHUB_EMAIL' => "user@test.org" } }

      Then {
        subject.configurate['APP_NAME'].must_equal "strawberry_field_app"
        subject.configurate['DOCKERHUB_EMAIL'].must_equal "user@test.org" }
    end
  end

  describe ":greenfield" do

    Given { subject.greenfield }
    Then {
      assert_file '.circleci'
      assert_file '.circleci/config.yml'
      assert_file '.circleci/config.yml.workflow-example'
      assert_file 'docker'
      assert_file 'docker/containers'
      assert_file 'docker/containers/app'
      assert_file 'docker/containers/app/development.env'
      assert_file 'docker/containers/app/production.env'
      assert_file 'docker/containers/database'
      assert_file 'docker/containers/database/development.env'
      assert_file 'docker/containers/database/production.env'
      assert_file 'docker/containers/web'
      assert_file 'docker/containers/web/app.conf'
      assert_file 'docker/containers/web/production.env'
      assert_file 'docker/env_files'
      assert_file 'docker/env_files/circleci.env'
      assert_file 'docker/keys'
      assert_file 'docker/overrides'
      assert_file 'docker/overrides/circleci.yml'
      assert_file 'docker/overrides/production.yml'
      assert_file 'docker/containers/app/Dockerfile' }




#   end
#
#   describe "generate_key" do
#
#     Given { subject.generate_key('circleci') }
#
#     Then { assert_file 'docker/keys/circleci.key' }
#   end
#
#   describe "obfuscate" do
#
#     Then { refute File.exist? 'docker/keys/circleci.key' }
#
#     describe "with ENV['CIRCLE_KEY'] set" do
#
#       Given(:passkey) { "HidqS1dbAZXFDGiWGGk3Zw==" }
#       Given { ENV['CIRCLECI_KEY'] = passkey }
#       Given { subject.obfuscate('circleci') }
#
#       Then { assert_file 'docker/env_files/circleci.env.enc' }
#     end
#
#     describe "ENV['CIRCLE_KEY'] = nil " do
#
#       Given { ENV['CIRCLECI_KEY'] = nil }
#       Given { assert ENV['CIRCLECI_KEY'].nil? }
#
#       describe "without dkfile" do
#
#         Given { refute File.exist? '.circleci/keys/circleci.key' }
#
#         describe "must raise error" do
#
#           Given(:error) { HandsomeFencer::CircleCI::Crypto::DeployKeyError }
#
#           Then { assert_raises(error) { subject.obfuscate('circleci') } }
#         end
#       end
#
#       describe "with dkfile" do
#
#         Given { subject.generate_key('circleci') }
#         Given { subject.obfuscate('circleci') }
#
#         Then { assert_file 'docker/env_files/circleci.env.enc' }
#
#         describe "expose" do
#
#           Given { File.delete('docker/env_files/circleci.env') }
#           Given { subject.expose('circleci') }
#
#           Then { assert_file 'docker/env_files/circleci.env' }
#         end
#       end
#     end
#
#     describe "development" do
#
#       Given { File.delete 'docker/keys/development.key'}
#       Given { refute File.exist? 'docker/keys/development.key'}
#       Given { refute File.exist? 'docker/containers/app/development.env.enc' }
#       Given { subject.generate_key('development') }
#       Given { subject.obfuscate('development') }
#
#       Then { assert_file 'docker/containers/database/development.env.enc' }
#
#       describe "expose" do
#
#         Given { File.delete 'docker/containers/database/development.env' }
#         Given { refute File.exist? 'docker/containers/database/development.env' }
#         Given { subject.expose('development') }
#
#         Then { assert File.exist? 'docker/containers/database/development.env' }
#       end
#     end
  end
end
