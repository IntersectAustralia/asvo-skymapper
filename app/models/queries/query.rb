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

  def construct_filter_adql(service)
    filter_adql = ''
    if filters
      filters.each do |filter|
        filter_adql += "AND #{service[:fields]["#{filter.name}_field".to_sym]} >= #{filter.min}\n" unless filter.min.blank?
        filter_adql += "AND #{service[:fields]["#{filter.name}_field".to_sym]} <= #{filter.max}\n" unless filter.max.blank?
      end
    end
    filter_adql
  end

  def filters_valid
    return unless filters
    filters.each do |filter|
      unless filter.valid?
        errors.add(:filters, "Invalid filter #{filter.name}")
      end
    end
  end

  protected

  def clean(value)
    value = value.to_s.gsub(/\s+/, '') if value
    value
  end

end