class PointQuery < Query

  PARAMETER_FIELDS = [:ra, :dec, :sr]

  attr_accessor *PARAMETER_FIELDS
  attr_accessor :filters

  validates :ra, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validates :dec, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validates :sr, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 10 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validate :filters, :filters_valid

  before_validation :clean_values

  def initialize(args = {})
    super(args)
    if args[:limit]
      @limit = args[:limit]
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