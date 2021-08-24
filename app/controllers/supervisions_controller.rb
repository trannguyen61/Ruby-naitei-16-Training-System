class SupervisionsController < CourseMembersController
  def create
    supervision = @course.supervisions.build user_id: @user.id
    if supervision.save
      success_respond t("add_member_success"), @course
    else
      fail_respond supervision.errors.full_messages.to_sentence, @course
    end
  end

  def destroy
    supervision = Supervision.find_by id: params[:id]
    fail_respond t("data_not_found") unless supervision
    @course = supervision.course
    if supervision.destroy
      success_respond t("delete_member_success"), @course
    else
      fail_respond t("delte_member_fail"), @course
    end
  end
end
