class CelebrationEventsController < ApplicationController
  def index
    @future_celebration_events = CelebrationEvent.order(date: :desc).where(
      date: (Time.now.at_beginning_of_day + 1.day)..
    )
    @celebration_events = CelebrationEvent.order(date: :desc).where(
      date: (Time.now.at_beginning_of_day - 2.weeks)..(Time.now.at_beginning_of_day)
    )
  end

  def retry
    # TODO
  end
end
