module CelebrationEventsHelper
    def distance_to_date_in_words date
        diff_in_minutes = ((Time.current() - date.at_beginning_of_day()) / 60).round
        if diff_in_minutes.abs() <= 1440
            return 'Today'
        elsif diff_in_minutes < 0
            return 'in ' + distance_of_time_in_words_to_now(date)
        else
            return distance_of_time_in_words_to_now(date) + ' ago'
        end
    end
end
