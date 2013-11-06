module SearchHelper

  def session_param(type, param, default = nil)
    return session[:search][:params][param] if session[:search] and session[:search][:type] == type
    default
  end

  def split_fields_by_group(fields)
    table_fields = {}
    fields.each do |field|
      group = field[:group] ? field[:group] : 'none'
      table_fields[group] ||= []
      table_fields[group] << field
    end
    table_fields
  end

end
