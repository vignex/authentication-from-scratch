class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def send_confirmation_mail(user)
    @user = user
    mail(to: @user.email, subject: 'User Registration confirmation')
  end
end
