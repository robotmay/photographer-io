class CompleteProcessingWorker
  include Sidekiq::Worker
  sidekiq_options queue: :events

  def perform(photo_id)
    photo = Photograph.find(photo_id)
    photo.complete_image_processing
  end
end
