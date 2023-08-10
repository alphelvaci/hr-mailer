class DailyCelebrationJob < ApplicationJob
  queue_as :default

  def perform()
    CelebrationEvent.celebrate_todays_events
  end
end
