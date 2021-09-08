module SessionsHelper
  def current_user? user
    user && user == current_user
  end

  def store_location
    session[:forwading_url] = request.original_url if request.get?
  end
end
