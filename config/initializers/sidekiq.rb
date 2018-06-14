Sidekiq.configure_client do |config|
  Sidekiq::Status.configure_client_middleware config, expiration: 1.day
end

Sidekiq.configure_server do |config|
  Sidekiq::Status.configure_server_middleware config, expiration: 1.day
  Sidekiq::Status.configure_client_middleware config, expiration: 1.day
end
