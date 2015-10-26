class CardsMailer < ActionMailer::Base
  default from: ENV['DEFAULT_EMAIL_FROM_CARDS']

  def pending_cards_notification(user)
    @user = user
    mail(to: @user.email, subject: t("mailer_date_review"))
  end
end
