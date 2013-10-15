class Query
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  def request
    raise NotImplementedError
  end

  protected

  def clean(value)
    value = value.gsub(/\s+/, '') if value
    value
  end

end