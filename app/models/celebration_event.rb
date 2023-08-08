class CelebrationEvent < ApplicationRecord
    belongs_to :recipient
    belongs_to :cc_recipient, class_name: "Recipient", optional: true

    validates :reason, presence: true, inclusion: ['birthday', 'work_anniversary']
    validates :date, presence: true
    validates :status, presence: true, inclusion: ['pending', 'error', 'sent']
    validates :recipient, presence: true

    def self.celebrate_todays_events
        events = CelebrationEvent.where(date: Time.now).where.not(status: 'sent')

        for event in events
            begin
                if event.reason == 'birthday'
                    CelebrationMailer.with(recipient: event.recipient).birthday_email.deliver_now
                elsif event.reason == 'work_anniversary'
                    CelebrationMailer.with(recipient: event.recipient).work_anniversary_email.deliver_now
                end
                event.error_message = nil
                event.status = 'sent'
            rescue => error
                event.error_message = error.inspect
                event.status = 'error'
            ensure
                event.save()
            end
        end
    end

    def self.generate_future_celebration_events
        # TODO simplify this function

        birthday_recipients =  Recipient.active.where([
            "CAST(strftime('%m', birth_date) AS INTEGER) = ? AND CAST(strftime('%d', birth_date) AS INTEGER) >= ?",
            Time.now.month,
            Time.now.day
        ]).or(Recipient.where([
            "CAST(strftime('%m', birth_date) AS INTEGER) = ? AND CAST(strftime('%d', birth_date) AS INTEGER) <= ?",
            Time.now.month + 1,
            Time.now.day
        ]))

        for recipient in birthday_recipients do
            CelebrationEvent.find_or_create_by(
                reason: 'birthday',
                date: recipient.birth_date.change(year: 2023),
                recipient: recipient,
            ) do |new_celebration_event|
                new_celebration_event.status = 'pending'
                new_celebration_event.cc_recipient = recipient.manager
            end
        end

        work_anniversary_recipients =  Recipient.active.where([
            "CAST(strftime('%m', employment_start_date) AS INTEGER) = ? AND CAST(strftime('%d', employment_start_date) AS INTEGER) >= ?",
            Time.now.month,
            Time.now.day
        ]).or(Recipient.where([
            "CAST(strftime('%m', employment_start_date) AS INTEGER) = ? AND CAST(strftime('%d', employment_start_date) AS INTEGER) <= ?",
            Time.now.month + 1,
            Time.now.day
        ]))

        for recipient in work_anniversary_recipients do
            CelebrationEvent.find_or_create_by(
                reason: 'work_anniversary',
                date: recipient.employment_start_date.change(year: 2023),
                recipient: recipient,
            ) do |new_celebration_event|
                new_celebration_event.status = 'pending'
                new_celebration_event.cc_recipient = recipient.manager
            end
        end

        return true
    end
end
