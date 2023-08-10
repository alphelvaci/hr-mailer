class WeeklyRecipientRefreshJob < ApplicationJob
  queue_as :default

  def perform()
    Recipient.refresh_all
  end
end
