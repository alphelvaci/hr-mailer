class CelebrationEvent < ApplicationRecord
  enum :reason, { birthday: 'birthday', work_anniversary: 'work_anniversary' }
  enum :status, { pending: 'pending', pending_retry: 'pending_retry', error: 'error', sent: 'sent' }, default: :pending

  belongs_to :recipient
  belongs_to :cc_recipient, class_name: 'Recipient', optional: true

  validates :reason, :date, :status, :recipient, presence: true

  def celebrate
    if reason == 'birthday'
      CelebrationMailer.with(recipient:).birthday_email.deliver_now
    elsif reason == 'work_anniversary'
      CelebrationMailer.with(recipient:).work_anniversary_email.deliver_now
    end
    self.error_message = nil
    self.status = 'sent'
  rescue StandardError => e
    self.error_message = e.inspect
    self.status = 'error'
  ensure
    save
  end

  def self.celebrate_todays_events
    events = CelebrationEvent.where(date: Time.now).where.not(status: 'sent')

    for event in events
      event.celebrate
    end
  end

  def self.generate_future_celebration_events
    # TODO: simplify this function

    birthday_recipients = Recipient.active.where(
      [
        'EXTRACT(MONTH FROM birth_date) = ? AND EXTRACT(DAY FROM birth_date) >= ?',
        Time.now.month,
        Time.now.day
      ]
    ).or(
      Recipient.active.where(
        [
          'EXTRACT(MONTH FROM birth_date) = ? AND EXTRACT(DAY FROM birth_date) <= ?',
          Time.now.month + 1,
          Time.now.day
        ]
      )
    )

    for recipient in birthday_recipients do
      CelebrationEvent.find_or_create_by(
        reason: 'birthday',
        date: recipient.birth_date.change(year: 2023),
        recipient:
      ) do |new_celebration_event|
        new_celebration_event.cc_recipient = recipient.manager
      end
    end

    work_anniversary_recipients = Recipient.active.where(
      [
        'EXTRACT(MONTH FROM employment_start_date) = ? AND EXTRACT(DAY FROM employment_start_date) >= ?',
        Time.now.month,
        Time.now.day
      ]
    ).or(
      Recipient.active.where(
        [
          'EXTRACT(MONTH FROM employment_start_date) = ? AND EXTRACT(DAY FROM employment_start_date) <= ?',
          Time.now.month + 1,
          Time.now.day
        ]
      )
    )

    for recipient in work_anniversary_recipients do
      CelebrationEvent.find_or_create_by(
        reason: 'work_anniversary',
        date: recipient.employment_start_date.change(year: 2023),
        recipient:
      ) do |new_celebration_event|
        new_celebration_event.cc_recipient = recipient.manager
      end
    end

    true
  end
end
