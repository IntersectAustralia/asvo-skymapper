module SearchHelper

  def session_param(type, param, default = nil)
    return session[:search][:params][param] if session[:search] and session[:search][:type] == type
    default
  end

end
