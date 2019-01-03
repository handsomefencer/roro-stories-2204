module Roro

  class CLI < Thor

    include Thor::Actions

    desc "ruby_gem", "Generate files for containerized gem testing, CircleCI, and releasing to RubyGems."
    method_option :rubies, type: :array, banner: "2.5.3 2.4.2"

    def ruby_gem
      rubies = options["rubies"] || ["2.5.3", "2.6.0"]
      copy_file 'ruby_gem/docker-compose.yml', 'docker-compose.yml'
      copy_file 'ruby_gem/config.yml', '.circleci/config.yml'
      copy_file 'ruby_gem/setup-gem-credentials.sh', '.circleci/setup-gem-credentials.sh'
      directory 'ruby_gem/docker', 'docker', { ruby_version: "2.5"}

      rubies.each do |ruby|
        rubydash = ruby.gsub('.', '-')
        rubyunderscore = ruby.gsub('.', '_')
        doc_loc = "docker/containers/#{rubyunderscore}/Dockerfile"
        content = <<-EOM

  app-#{rubydash}:
    build:
      context: .
      dockerfile: #{doc_loc}
    command: rake test
        EOM
        append_to_file 'docker-compose.yml', content
        template 'ruby_gem/docker/containers/app/Dockerfile.tt', doc_loc, {ruby_version: ruby}
        # append_to_file 'docker-compose.yml', "\n  app-#{ruby}:\n    build:\n\s\s\s\s\s\scontext:"
      end
      # byebug

      # end
#       <<EOF
#    This is the first way of creating
#    here document ie. multiple line string.
# EOF
      # %w[app web].each do |container|
      #   options = {
      #     email: @env_hash['DOCKERHUB_EMAIL'],
      #     app_name: @env_hash['APP_NAME'] }
      #
      #   template("docker/containers/#{container}/Dockerfile.tt", "docker/containers/#{container}/Dockerfile", options)
      # end
    end
  end
end