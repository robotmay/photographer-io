class ImageWorker
  include Sidekiq::Worker
  include Timeout
  sidekiq_options queue: :photos

  def perform(photo_id, source, target, size, encode_opts)
    timeout(60) do
      photo = Photograph.find(photo_id)
      source = photo.send(source)
      if source.present?
        image = source.thumb(size).encode(:jpg, encode_opts)

        if photo.metadata.rotate?
          image = image.process(:rotate, photo.metadata.rotate_by)
        end

        photo.send("#{target}=", image)
        photo.save!
      else
        raise "Source doesn't exist yet"
      end
    end
  end
end
