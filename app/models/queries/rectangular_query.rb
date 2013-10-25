class RectangularQuery < Query

  PARAMETER_FIELDS = [:ra_min, :ra_max, :dec_min, :dec_max]
  TABLE_FIELDS = [:table_name, :ra_field, :dec_field]

  attr_accessor *PARAMETER_FIELDS
  attr_accessor *TABLE_FIELDS
  attr_accessor :filters

  validates :table_name, presence: true
  validates :ra_field, presence: true
  validates :dec_field, presence: true
  validates :ra_min, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validates :ra_max, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validates :ra_max, numericality: { greater_than: Proc.new { |q| q.ra_min.to_f } }, if: 'ra_min'
  validates :dec_min, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validates :dec_max, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validates :dec_max, numericality: { greater_than: Proc.new { |q| q.dec_min.to_f } }, if: 'dec_min'
  validate :filters, :filters_valid

  before_validation :clean_values

  def to_adql

    ra_box_center = ((ra_min.to_f + ra_max.to_f) * 0.5).to_s
    dec_box_center = ((dec_min.to_f + dec_max.to_f) * 0.5).to_s
    box_width = (ra_max.to_f - ra_min.to_f).to_s
    box_height = (dec_max.to_f - dec_min.to_f).to_s

    <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM #{table_name}
    WHERE
        1=CONTAINS(POINT('ICRS', #{ra_field}, #{dec_field}),
                   BOX('ICRS', #{ra_box_center}, #{dec_box_center}, #{box_width}, #{box_height}))
#{construct_filter_adql}
    END_ADQL
  end

  def all_fields
    PARAMETER_FIELDS.concat(TABLE_FIELDS)
  end

end