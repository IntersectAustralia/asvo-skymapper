class Query
  include ActiveModel::Validations

  def request
    raise NotImplementedError
  end

end