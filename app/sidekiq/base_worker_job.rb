class BaseWorkerJob
  include Sidekiq::Job

  def perform(*args)
    BaseWorker.perform_now
  end
end
