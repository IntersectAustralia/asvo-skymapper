class Query
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  FILE_TYPE = %w(CSV VOTable)

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
    clean_values
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
        filter_adql += "AND #{service[:fields][filter.name.to_sym][:field]} >= #{filter.min}\n" unless filter.min.blank?
        filter_adql += "AND #{service[:fields][filter.name.to_sym][:field]} <= #{filter.max}\n" unless filter.max.blank?
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

  def search_file_valid
    if file and File.file? file
      csv = CSV.parse(File.read(file), headers: true)
      return errors.add(:file, 'File must not be empty') if csv.empty?
      return errors.add(:file, 'File must have less than 50 points') if csv.size > 50
      csv.each_with_index do |row, index|
        query_args = { sr: sr }
        headers = row.headers.map { |h| h.strip.downcase if h }
        fields = row.fields
        if headers.index('ra').blank? or headers.index('dec').blank?
          errors.add(:file, 'File must include headers RA and DEC')
        else
          query_args[:ra] = fields[headers.index('ra')] if headers.index('ra') and fields[headers.index('ra')]
          query_args[:dec] = fields[headers.index('dec')] if headers.index('dec') and fields[headers.index('dec')]
          query = PointQuery.new(query_args)
          unless query.valid?
            query.errors.messages[:ra].each { |error| errors.add(:file, "Line #{index + 1}: Right ascension #{error}") } if query.errors.messages[:ra]
            query.errors.messages[:dec].each { |error| errors.add(:file, "Line #{index + 1}: Declination #{error}") } if query.errors.messages[:dec]
          end
        end
      end
    else
      errors.add(:file, 'File cannot be read')
    end
  end

  protected

  def clean(value)
    #check for degrees regex
    if value && (value.respond_to? :match)
       return value unless value.match("^([+-]?[0-9][0-9])[:\\s]?([0-6][0-9])[:\\s]?([0-6][0-9])(.[0-9]{1,5})?$").nil?
    end
    value = value.to_s.gsub(/\s+/, '') if value
    value
  end

end