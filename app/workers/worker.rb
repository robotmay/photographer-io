class Worker
  include Sidekiq::Worker

  def perform(klass, id, method, *args)
    model = klass.constantize.find(id)
    model.send(method, *args)
  end
end
