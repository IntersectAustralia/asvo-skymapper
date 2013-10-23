class PointQuery < Query

  PARAMETER_FIELDS = [:ra, :dec, :sr]
  TABLE_FIELDS = [:table_name, :ra_field, :dec_field]

  attr_accessor *PARAMETER_FIELDS
  attr_accessor *TABLE_FIELDS
  attr_accessor :filters

  validates :table_name, presence: true
  validates :ra_field, presence: true
  validates :dec_field, presence: true
  validates :ra, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, format: { with: /^-?\d*(\.\d{1,5})?$/ }
  validates :dec, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, format: { with: /^-?\d*(\.\d{1,5})?$/ }
  validates :sr, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validate :filters, :filters_valid

  before_validation :clean_values

  def to_adql
    args = to_args

    if filters
      filter_adql = ''
      filters.each do |filter|
        filter_adql += "AND #{filter.field} >= #{filter.min}\n" unless filter.min.blank?
        filter_adql += "AND #{filter.field} <= #{filter.max}\n" unless filter.max.blank?
      end

    end

    <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM #{args[:table_name]}
    WHERE
        1=CONTAINS(POINT('ICRS', #{args[:ra_field]}, #{args[:dec_field]}),
                   CIRCLE('ICRS', #{args[:ra]}, #{args[:dec]}, #{args[:sr]}))
#{filter_adql}
    END_ADQL
  end

  def all_fields
    PARAMETER_FIELDS.concat(TABLE_FIELDS)
  end

  def filters_valid
    return unless filters
    filters.each do |filter|
      unless filter.valid?
        errors.add(:filters, "Invalid filter #{filter.field}")
      end
    end
  end

end