class UserMailer < ApplicationMailer
  def add_to_course_email user, course, enrollment
    @user = user
    @course = course
    @enrollment = enrollment
    mail to: @user.email, subject: t(".subject")
  end

  def del_from_course_email user, course
    @user = user
    @course = course
    mail to: @user.email, subject: t(".subject")
  end
end
