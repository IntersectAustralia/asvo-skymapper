require 'csv'

class BulkCatalogueQuery < Query

  PARAMETER_FIELDS = [:file, :sr]

  attr_accessor *PARAMETER_FIELDS

  validates :file, presence: true
  validates :sr, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 0.05 }, format: { with: /^-?\d*(\.\d{1,8})?$/, message: 'must be a number with 8 decimal places' }
  validate :file, :valid_search_file

  before_validation :clean_values

  def valid_search_file
    if file and File.file? file
      csv = CSV.parse(File.read(file), headers: true)
      if csv.empty?
        errors.add(:file, 'must not be empty')
      else
        csv.each_with_index do |row, index|
          query_args = { sr: sr }
          headers = row.headers.map { |h| h.strip.downcase if h }
          fields = row.fields
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
      errors.add(:file, 'must be a file')
    end
  end

  def to_adql(service)
    point_queries = ''
    csv = CSV.parse(File.read(file), headers: true)
    csv.each do |row|
      headers = row.headers.map { |h| h.strip.downcase }
      fields = row.fields
      ra = fields[headers.index('ra')]
      dec = fields[headers.index('dec')]
      point_queries += "OR\n" unless point_queries.blank?
      point_queries += "1=CONTAINS(POINT('ICRS', #{service[:fields][:ra][:field]}, #{service[:fields][:dec][:field]}), CIRCLE('ICRS', #{clean(ra)}, #{clean(dec)}, #{clean(sr)}))\n"
    end
    <<-END_ADQL
SELECT
    *
    FROM #{service[:table_name]}
    WHERE
#{point_queries}
    END_ADQL
  end

  def all_fields
    PARAMETER_FIELDS
  end

end