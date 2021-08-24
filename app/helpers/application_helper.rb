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
end
