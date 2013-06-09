class MetadataWorker
  include Sidekiq::Worker
  include Timeout
  sidekiq_options queue: :photos

  def perform(metadata_id)
    timeout(60) do
      metadata = Metadata.find(metadata_id)
      metadata.extract_from_photograph
      metadata.processing = false
      metadata.save
      metadata.photograph.trigger_image_processed_push
    end
  end
end
