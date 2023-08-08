module CelebrationEventsHelper
    def distance_to_date_in_words date
        today = Time.now.at_beginning_of_day()
        date = date.at_beginning_of_day().change(offset: Time.now.zone)
        
        if date == today
            return 'Today'
        elsif date > today
            return 'in ' + distance_of_time_in_words(today, date)
        else
            return distance_of_time_in_words(date, today) + ' ago'
        end
    end
end
