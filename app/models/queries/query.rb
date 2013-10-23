class Query
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  def initialize(args = nil)
    from_args(args) if args
  end

  def to_args
    args = {}
    all_fields.each do |field|
      args[field] = self.method(field).call
    end
    args
  end

  def from_args(args)
    all_fields.each do |field|
     self.method("#{field}=".to_sym).call(args[field]) if args[field]
   end
  end

  def clean_values
    all_fields.each do |field|
      self.method("#{field}=".to_sym).call(clean(self.method(field).call))
    end
  end

  def all_fields
    []
  end

  protected

  def clean(value)
    value = value.to_s.gsub(/\s+/, '') if value
    value
  end

end