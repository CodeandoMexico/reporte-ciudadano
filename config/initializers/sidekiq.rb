if Rails.env.production?
  Sidekiq.configure_server do |config|
    if ENV['REDIS_PORT_6379_TCP_ADDR'] and ENV[''REDIS_PORT_6379_TCP_PORT'']
      config.redis = { url: "redis://#{ENV['REDIS_PORT_6379_TCP_ADDR']}:#{ENV['REDIS_PORT_6379_TCP_PORT']}/0", namespace: 'Tyresearch' }
    else
      config.redis = { url: ENV["REDISCLOUD_URL"], size: 3 }
    end

    database_url = ENV['DATABASE_URL']
    if database_url
      ENV['DATABASE_URL'] = "#{database_url}?pool=20"
      ActiveRecord::Base.establish_connection
    end
  end

  Sidekiq.configure_client do |config|
    config.redis = {size: 1}
  end
end
