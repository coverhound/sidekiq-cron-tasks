module Sidekiq
  module Cron
    module Tasks
      class Configuration
        attr_accessor :file, :prefix, :env

        def initialize
          @prefix = "sidekiq_cron"
          if defined?(::Rails)
            @file = ::Rails.root.join("config", "sidekiq_cron.yml")
            @env  = ::Rails.env
          end
        end

        def file
          @file || @default_file.call
        end

        def schedule
          @schedule ||= File.exist?(file) ? YAML.load_file(file).fetch(env, {}) : {}
        end
      end
    end
  end
end
