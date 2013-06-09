class MentionWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low

  def perform(photograph_id)
    photo = Photograph.find(photograph_id)
    photo.auto_mention
  end
end
