require 'csv'

class BulkImageQuery < Query

  PARAMETER_FIELDS = [:file, :sr]

  attr_accessor *PARAMETER_FIELDS

  validates :file, presence: true
  validate :file, :search_file_valid

  before_validation :clean_values

  def to_points
    points = []
    csv = CSV.parse(File.read(file), headers: true)
    csv.each do |row|
      headers = row.headers.map { |h| h.strip.downcase }
      fields = row.fields
      ra = fields[headers.index('ra')]
      dec = fields[headers.index('dec')]
      points << { ra: ra, dec: dec }
    end
    points
  end

  def all_fields
    PARAMETER_FIELDS
  end

end