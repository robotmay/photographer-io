Airbrake.configure do |config|
  config.api_key = '671ee64f78a3e1221ef87decf1461a30'
  config.host    = 'errors.throlk.im'
  config.port    = 80
  config.secure  = config.port == 443
end

