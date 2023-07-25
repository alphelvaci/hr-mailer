class LogsController < ApplicationController
  def index
    @logs = LogEntry.order(date: :desc).all
  end

  def retry
    # TODO
  end
end
