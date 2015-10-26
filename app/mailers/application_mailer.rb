class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_EMAIL_FROM_CARDS']
  layout 'mailer'
end
