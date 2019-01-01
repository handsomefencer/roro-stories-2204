# use SSHKit directly instead of Capistrano
require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL

deploy_tag =      ENV['DEPLOY_TAG']
app_name =        ENV['APP_NAME']
hostname =        ENV['SERVER_HOST']
user =            ENV['SERVER_USER']
dockerhub_user =  ENV['DOCKERHUB_USER']
dockerhub_pass =  ENV['DOCKERHUB_PASS']
dockerhub_org =   ENV['DOCKERHUB_ORG']
port =            ENV['SERVER_PORT']
deploy_env =      ENV['DEPLOY_ENV'] || :production
deploy_path =     ENV['APP_NAME']

server = SSHKit::Host.new(hostname: hostname, port: port, user: user)

namespace :deploy do

  desc 'copy to server files needed to run and manage Docker containers'
  task :configs do

    on server do
      within deploy_path do
        upload! File.expand_path('../docker-compose.yml', __dir__), 'docker-compose.yml'

        upload! File.expand_path('../docker', __dir__), '.', recursive: true
        execute 'apt', 'install', '-y', 'ruby'
        execute 'gem', 'install', 'handsome_fencer-circle_c_i'
        execute 'handsome_fencer-circle_c_i', 'expose', 'production'
        execute :source, './docker/env_files/production.env'
      end
    end
  end

  # desc 'copy production key to server'
  # task :production_key do
  #
  #   on server do
  #     within deploy_path do
  #
  #       upload! '.circleci/keys/production.key', '.circleci/keys/production.key'
  #     end
  #   end
  # end
  #
  # desc 'expose production environment'
  # task :expose_production_environment do
  #
  #   on server do
  #     within deploy_path do
  #       execute 'snap', 'install', 'ruby', '--classic'
  #       execute 'gem', 'install', 'handsome_fencer-circle_c_i'
  #       execute 'handsome_fencer-circle_c_i', 'expose', 'production'
  #     end
  #   end
  # end
end

namespace :docker do

  desc 'logs into Docker Hub for pushing and pulling'
  task :login do
    on server do
      execute "mkdir -p #{deploy_path}"
      within deploy_path do
        execute 'docker', 'login', '-u', dockerhub_user, '-p', dockerhub_pass
      end
    end
  end

  desc 'stops all Docker containers via Docker Compose'
  task stop: 'deploy:configs' do
    on server do
      within deploy_path do
        with rails_env: deploy_env, deploy_tag: deploy_tag do
          execute 'docker-compose', 'stop'
      end
    end
    end
  end

  desc 'starts all Docker containers via Docker Compose'
  task start: 'deploy:configs' do
    on server do
      within deploy_path do
        with rails_env: deploy_env, deploy_tag: deploy_tag do
          execute 'docker-compose', 'docker-compose', '-f', 'docker-compose.yml', '-f', 'docker/overrides/docker-compose.production.yml',
          'up', '-d'
          execute 'echo', deploy_tag , '>', 'deploy.tag'
        end
      end
    end
  end

  desc 'pulls images from Docker Hub'
  task pull: 'docker:login' do
    on server do
      within deploy_path do
        images = [
          "#{dockerhub_org}/#{app_name}_app:#{deploy_tag}",
          "#{dockerhub_org}/#{app_name}_web:#{deploy_tag}",
          "postgres:9.4.5"
        ]
        images.each do |image|
        execute 'docker', 'pull', "#{image}"
        end
      end
    end
  end

  desc 'runs database migrations in application container via Docker Compose'
  task migrate: 'deploy:configs' do
    on server do
      within deploy_path do
        with rails_env: deploy_env, deploy_tag: deploy_tag do
          execute 'docker-compose', '-f', 'docker-compose.yml', '-f', 'docker/overrides/docker-compose.production.yml',
          'exec', 'app', "bin/rails", 'db:create', 'db:migrate'
        end
      end
    end
  end

  desc 'pulls images, stops old containers, updates the database, and starts new containers'
  task deploy: %w{docker:pull docker:stop docker:migrate docker:start }
end
