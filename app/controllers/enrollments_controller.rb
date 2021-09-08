class EnrollmentsController < CourseMembersController
  before_action :load_enrollment, except: :create
  authorize_resource

  def show
    @subject_statuses = @enrollment.statuses.subjects_ordered
  end

  def create
    enrollment = @course.enrollments.build user_id: @user.id
    if enrollment.save
      success_respond t("add_member_success"), @course
    else
      fail_respond enrollment.errors.full_messages.to_sentence, @course
    end
  end

  def destroy
    if @enrollment.destroy
      success_respond t("delete_member_success"), @course
    else
      fail_respond t("delete_member_fail"), @course
    end
  end

  private

  def load_enrollment
    @enrollment = Enrollment.find_by id: params[:id]
    if @enrollment
      @course = @enrollment.course
    else
      fail_respond t("data_not_found"), courses_path
    end
  end
end
