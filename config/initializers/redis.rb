if ENV['REDIS_PROVIDER']
  uri = URI.parse(ENV['REDIS_PROVIDER'])
  Redis.current = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end
