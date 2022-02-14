class UserMailer < ApplicationMailer
  def user_feedback(feedback)
    @user = feedback
    mail(to: "nayan.affimintus@gmail.com", subject: "Feedback Email")
  end
end