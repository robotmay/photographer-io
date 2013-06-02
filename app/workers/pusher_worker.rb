class PusherWorker
  include Sidekiq::Worker
  sidekiq_options queue: :events

  def perform(channel, event, body = {})
    body[:type] = event

    $pubnub.publish(
      channel: channel,
      message: body,
      callback: -> (message) {}
    )
  end
end
