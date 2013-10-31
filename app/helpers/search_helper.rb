module SearchHelper

  def session_param(param, default = nil)
    return session[:search][:params][param] if session[:search]
    default
  end

end
