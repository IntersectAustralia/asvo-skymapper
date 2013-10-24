class PointQuery < Query

  PARAMETER_FIELDS = [:ra, :dec, :sr]
  TABLE_FIELDS = [:table_name, :ra_field, :dec_field]

  attr_accessor *PARAMETER_FIELDS
  attr_accessor *TABLE_FIELDS
  attr_accessor :filters

  validates :table_name, presence: true
  validates :ra_field, presence: true
  validates :dec_field, presence: true
  validates :ra, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validates :dec, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validates :sr, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 10 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validate :filters, :filters_valid

  before_validation :clean_values

  def to_adql
    <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM #{table_name}
    WHERE
        1=CONTAINS(POINT('ICRS', #{ra_field}, #{dec_field}),
                   CIRCLE('ICRS', #{ra}, #{dec}, #{sr}))
#{construct_filter_adql}
    END_ADQL
  end

  def all_fields
    PARAMETER_FIELDS.concat(TABLE_FIELDS)
  end

end