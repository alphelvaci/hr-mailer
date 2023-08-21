class DailyRetryJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    CelebrationEvent.retry_todays_events
  end
end
