class CelebrationEvent < ApplicationRecord
  enum :reason, { birthday: 'birthday', work_anniversary: 'work_anniversary' }
  enum :status, { pending: 'pending', pending_retry: 'pending_retry', error: 'error', sent: 'sent' }, default: :pending

  belongs_to :recipient
  belongs_to :cc_recipient, class_name: 'Recipient', optional: true

  validates :reason, :date, :status, :recipient, presence: true

  def celebrate(retry_: false)
    if reason == 'birthday'
      CelebrationMailer.with(recipient:).birthday_email.deliver_now
    elsif reason == 'work_anniversary'
      CelebrationMailer.with(recipient:).work_anniversary_email.deliver_now
    end
    self.error_message = nil
    self.status = 'sent'
  rescue StandardError => e
    self.error_message = e.inspect
    self.status = retry_ == true ? 'error' : 'pending_retry'
  ensure
    save
  end

  def self.celebrate_todays_events
    events = CelebrationEvent.where(date: Time.now).where(status: 'pending')

    for event in events
      event.celebrate
    end
  end

  def self.retry_todays_events
    events = CelebrationEvent.where(date: Time.now).where(status: 'pending_retry')

    for event in events
      event.celebrate(retry_: true)
    end

    failed_events = CelebrationEvent.where(date: Time.now).where(status: 'error')

    for event in failed_events
      AdminMailer.with(admin: Admin.first, celebration_event: event).failed_celebration_email.deliver_later
    end
  end

  def self.generate_future_celebration_events
    days_ahead = 7

    birthday_recipients = Recipient.get_recipients_to_celebrate('birthday', days_ahead)
    for recipient in birthday_recipients do
      CelebrationEvent.find_or_create_by(
        reason: 'birthday',
        date: recipient.birth_date.change(year: 2023),
        recipient:
      ) do |new_celebration_event|
        new_celebration_event.cc_recipient = recipient.manager
      end
    end

    work_anniversary_recipients = Recipient.get_recipients_to_celebrate('work_anniversary', days_ahead)
    for recipient in work_anniversary_recipients do
      CelebrationEvent.find_or_create_by(
        reason: 'work_anniversary',
        date: recipient.employment_start_date.change(year: 2023),
        recipient:
      ) do |new_celebration_event|
        new_celebration_event.cc_recipient = recipient.manager
      end
    end
  end
end
