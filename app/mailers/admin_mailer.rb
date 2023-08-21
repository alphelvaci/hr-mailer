class AdminMailer < ApplicationMailer
  def failed_celebration_email
    @admin = params[:admin]
    @celebration_event = params[:celebration_event]
    mail(to: @admin.email, subject: 'Celebration Failed')
  end
end
