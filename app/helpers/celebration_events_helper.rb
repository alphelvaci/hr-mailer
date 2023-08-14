module CelebrationEventsHelper
  def distance_to_date_in_words(date)
    today = Time.now.at_beginning_of_day
    date = date.at_beginning_of_day.change(offset: Time.now.zone)

    if date == today
      'Today'
    elsif date > today
      'in ' + distance_of_time_in_words(today, date)
    else
      distance_of_time_in_words(date, today) + ' ago'
    end
  end
end
