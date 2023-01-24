class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  default from: Rails.application.credentials.sendmail[:sender]
end
