class EnrollmentsController < CourseMembersController
  def create
    if @course.enrollments.create user_id: @user.id
      success_respond t("add_member_success")
    else
      fail_respond @course.errors.full_messages.to_sentence
    end
  end

  def destroy; end
end
