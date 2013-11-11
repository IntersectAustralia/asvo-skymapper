require 'csv'

class BulkCatalogueQuery < Query

  PARAMETER_FIELDS = [:file, :sr]

  attr_accessor *PARAMETER_FIELDS

  validates :file, presence: true
  validate :file, :search_file_valid
  validates :sr, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 0.05 }, format: { with: /^-?\d*(\.\d{1,6})?$/, message: 'must be a number with a maximum of 6 decimal places' }

  before_validation :clean_values

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