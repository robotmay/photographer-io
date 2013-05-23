class PusherWorker
  include Sidekiq::Worker
  sidekiq_options queue: :events

  def perform(channel, event, body = {})
    Pusher.trigger(channel, event, body)
  end
end
