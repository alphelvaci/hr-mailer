# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Learn more: http://github.com/javan/whenever

every 1.day, at: '4:00 am' do
  runner 'DailyEventGenerationJob.perform_later'
end

every 1.day, at: '9:00 am' do
  runner 'DailyCelebrationJob.perform_later'
end

every 1.day, at: '11:00 am' do
  runner 'DailyRetryJob.perform_later'
end

every :monday, at: '6:00 am' do
  runner 'WeeklyRecipientRefreshJob.perform_later'
end
