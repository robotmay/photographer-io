if ENV['PUBNUB_PUBLISH_KEY'].present?
  $pubnub = Pubnub.new(
    publish_key: ENV['PUBNUB_PUBLISH_KEY'],
    subscribe_key: ENV['PUBNUB_SUBSCRIBE_KEY'],
    ssl: ENV['PUBNUB_SSL']
  )
end
