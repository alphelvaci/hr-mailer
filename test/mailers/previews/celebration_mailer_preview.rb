# Preview all emails at http://localhost:3000/rails/mailers/celebration_mailer
class CelebrationMailerPreview < ActionMailer::Preview
  def birthday_email
    CelebrationMailer.with(recipient: Recipient.last).birthday_email
  end

  def work_anniversary_email
    CelebrationMailer.with(recipient: Recipient.first).work_anniversary_email
  end
end
