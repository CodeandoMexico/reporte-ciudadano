if Rails.env.production?
  def docker_redis_url
    if ENV['REDIS_PORT_6379_TCP_ADDR'] and ENV['REDIS_PORT_6379_TCP_PORT']
      return "redis://#{ENV['REDIS_PORT_6379_TCP_ADDR']}:#{ENV['REDIS_PORT_6379_TCP_PORT']}/0"
    end
    nil
  end

  Sidekiq.configure_server do |config|
    if docker_redis_url
      config.redis = { url: docker_redis_url, size: 3 }
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
    if docker_redis_url
      config.redis = { url: docker_redis_url, size: 3 }
    else
      config.redis = { size: 3 }
    end
  end
end
