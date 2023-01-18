class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.mailjet[:sender]
  layout 'mailer'
end
