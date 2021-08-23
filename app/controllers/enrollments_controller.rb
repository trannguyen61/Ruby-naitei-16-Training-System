class EnrollmentsController < CourseMembersController
  def create
    enrollment = @course.enrollments.build user_id: @user.id
    if enrollment.save
      success_respond t("add_member_success")
    else
      fail_respond enrollment.errors.full_messages.to_sentence
    end
  end

  def destroy
    enrollment = Enrollment.find_by id: params[:id]
    fail_respond t("data_not_found") unless enrollment
    @course = enrollment.course
    if enrollment.destroy
      success_respond t("delete_member_success")
    else
      fail_respond t("delte_member_fail")
    end
  end
end
