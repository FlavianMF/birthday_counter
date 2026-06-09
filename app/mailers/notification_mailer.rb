class NotificationMailer < ApplicationMailer
  default from: -> { AppSetting.email_config['from_email'] || "birthday@example.com" }
  default_url_options[:host] = 'localhost' if Rails.env.test?

  def countdown_email(user, event)
    @user = user
    @event = event
    @days_left = (event.target_date.to_date - Date.today).to_i

    mail(to: @user.email, subject: "🎂 #{@days_left} dias para o aniversário de #{@event.name}!")
  end

  def invitation_email(email, event)
    @email = email
    @event = event
    @invitation_url = invite_url(token: @event.invitation_token)

    mail(to: @email, subject: "🎁 Você recebeu um presente surpresa: O aniversário de #{@event.name}!")
  end

  def guest_invitation_email(email, event, inviter)
    @email = email
    @event = event
    @inviter = inviter
    @url = event_url(@event)

    mail(to: @email, subject: "#{@inviter.name} te convidou para o aniversário de #{@event.name}!")
  end
end
