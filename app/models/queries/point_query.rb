class PointQuery < Query

  PARAMETER_FIELDS = [:ra, :dec, :sr]

  attr_accessor *PARAMETER_FIELDS
  attr_accessor :filters

  validates :ra, presence: true
  validate :ra, :ra_format_and_value
  validates :dec, presence: true
  validate :dec, :dec_format_and_value
  validates :sr, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 10 }, format: { with: /^-?\d*(\.\d{1,6})?$/, message: 'must be a number with a maximum of 6 decimal places' }
  validate :filters, :filters_valid

  before_validation :clean_values

  def initialize(args = {})
    super(args)
    if args[:limit] && args[:limit] != 'unlimited'
      @limit = "TOP #{args[:limit]}"
    elsif args[:limit].nil?
      @limit = 'TOP 1000'
    else
      @limit = nil
    end
  end

  def to_adql(service)
    <<-END_ADQL
SELECT
    #{@limit}
    *
    FROM #{service[:table_name]}
    WHERE
        1=CONTAINS(POINT('ICRS', #{service[:fields][:ra][:field]}, #{service[:fields][:dec][:field]}),
                   CIRCLE('ICRS', #{ra}, #{dec}, #{sr}))
#{construct_filter_adql(service)}
    END_ADQL
  end

  def all_fields
    PARAMETER_FIELDS
  end
end