class DailyEventGenerationJob < ApplicationJob
  queue_as :default

  def perform()
    CelebrationEvent.generate_future_celebration_events
  end
end
