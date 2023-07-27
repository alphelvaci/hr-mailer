class CelebrationEventsController < ApplicationController
  def index
    @celebration_events = CelebrationEvent.order(date: :desc).all
  end

  def retry
    # TODO
  end
end
