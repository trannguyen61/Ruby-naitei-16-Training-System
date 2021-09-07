class SupervisionsController < CourseMembersController
  before_action :load_supervision, except: :create
  authorize_resource

  def create
    supervision = @course.supervisions.build user_id: @user.id
    if supervision.save
      success_respond t("add_member_success"), @course
    else
      fail_respond supervision.errors.full_messages.to_sentence, @course
    end
  end

  def destroy
    if @supervision.destroy
      success_respond t("delete_member_success"), @course
    else
      fail_respond t("delte_member_fail"), @course
    end
  end

  private

  def load_supervision
    @supervision = Supervision.find_by id: params[:id]
    if @supervision
      @course = @supervision.course
    else
      fail_respond t("data_not_found"), courses_path
    end
  end
end
