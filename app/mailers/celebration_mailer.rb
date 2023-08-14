class CelebrationMailer < ApplicationMailer
  def birthday_email
    @recipient = params[:recipient]
    mail(
      to: @recipient.email,
      cc: @recipient.manager.blank? ? nil : @recipient.manager.email,
      subject: "Happy Birthday #{@recipient.first_name} #{@recipient.last_name}!"
    )
  end

  def work_anniversary_email
    @recipient = params[:recipient]
    @anniversary_year = DateTime.now.year - @recipient.employment_start_date.year
    mail(
      to: @recipient.email,
      cc: @recipient.manager.blank? ? nil : @recipient.manager.email,
      subject: "Happy Work Anniversary #{@recipient.first_name} #{@recipient.last_name}!"
    )
  end
end
