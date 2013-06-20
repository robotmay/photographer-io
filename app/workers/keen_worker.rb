class KeenWorker
  include Sidekiq::Worker
  sidekiq_options queue: :events

  def perform(*args)
    Keen.publish(*args)
  end
end
