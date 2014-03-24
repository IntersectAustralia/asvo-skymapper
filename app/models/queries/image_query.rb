class ImageQuery < Query

  PARAMETER_FIELDS = [:ra, :dec]

  attr_accessor *PARAMETER_FIELDS
  validates :ra, presence: true
  validate :ra, :ra_format_and_value
  validates :dec, presence: true
  validate :dec, :dec_format_and_value


  before_validation :clean_values

  def all_fields
    PARAMETER_FIELDS
  end

end