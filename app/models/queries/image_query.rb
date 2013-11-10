class ImageQuery < Query

  PARAMETER_FIELDS = [:ra, :dec]

  attr_accessor *PARAMETER_FIELDS

  validates :ra, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, format: { with: /^-?\d*(\.\d{1,6})?$/ }
  validates :dec, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, format: { with: /^-?\d*(\.\d{1,6})?$/ }

  before_validation :clean_values

  def all_fields
    PARAMETER_FIELDS
  end

end