class MetadataWorker
  include Sidekiq::Worker

  def perform(metadata_id)
    metadata = Metadata.find(metadata_id)
    metadata.extract_from_photograph
    metadata.save
  end
end
