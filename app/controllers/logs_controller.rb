class LogsController < ApplicationController
  def index
    @logs = LogEntry.all
  end

  def retry
    # TODO
  end
end
