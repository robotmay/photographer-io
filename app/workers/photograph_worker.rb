class PhotographWorker
  include Sidekiq::Worker

  def perform(photograph_id, method, *args)
    photo = Photograph.find(photograph_id)
    photo.send(method, *args)
  end
end
