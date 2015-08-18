class AppMailer < ActionMailer::Base
  default from: "info@mystore.com"

  def send_welcome_email(user)
    @user = user
    mail to: user.email, subject: "Welcome to MyStore"
  end
end
