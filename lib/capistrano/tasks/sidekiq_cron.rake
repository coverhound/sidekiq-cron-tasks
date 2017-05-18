namespace :deploy do
  desc "Updates Sidekiq::Cron jobs from configuration file"
  task sidekiq_cron: [:set_rails_env] do
    next unless fetch(:sidekiq_cron_enabled)
    on fetch(:sidekiq_cron_servers) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "sidekiq_cron:load"
        end
      end
    end
  end
  after "deploy:updated", "deploy:sidekiq_cron"
end

namespace :load do
  task :defaults do
    set :sidekiq_cron_role, fetch(:sidekiq_cron_role, :app)
    set :sidekiq_cron_servers, -> { primary(fetch(:sidekiq_cron_role)) }
    set :sidekiq_cron_enabled, fetch(:sidekiq_cron_enabled, false)
  end
end
