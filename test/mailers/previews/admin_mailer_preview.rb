# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def failed_celebration_email
    AdminMailer.with(admin: Admin.first, celebration_event: CelebrationEvent.first).failed_celebration_email
  end
end
