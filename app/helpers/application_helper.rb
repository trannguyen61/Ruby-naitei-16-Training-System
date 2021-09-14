module ApplicationHelper
  def full_title page_title
    base_title = t ".project_name"
    page_title.blank? ? base_title : [page_title, base_title].join(" | ")
  end

  def get_report_view
    if current_user.role_trainee?
      Settings.trainee_report
    else
      Settings.supervisor_report
    end
  end

  def hasnt_finished_course?
    @finished_rate != Settings.complete_rate
  end

  def get_btn_type
    hasnt_finished_course? ? "secondary" : "greeny"
  end

  def get_status_text
    if current_user.role_trainee?
      "to_complete_status"
    else
      "yet_completed_status"
    end
  end
end
