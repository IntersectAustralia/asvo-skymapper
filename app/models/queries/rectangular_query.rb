class RectangularQuery < Query

  PARAMETER_FIELDS = [:ra_min, :ra_max, :dec_min, :dec_max]

  attr_accessor *PARAMETER_FIELDS
  attr_accessor :filters

  validates :ra_min, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validates :ra_max, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validates :ra_max, numericality: { greater_than: Proc.new { |q| q.ra_min.to_f } }, if: 'ra_min'
  validates :dec_min, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validates :dec_max, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, format: { with: /^-?\d*(\.\d{1,8})?$/ }
  validates :dec_max, numericality: { greater_than: Proc.new { |q| q.dec_min.to_f } }, if: 'dec_min'
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
    ra_box_center = ((ra_min.to_f + ra_max.to_f) * 0.5).to_s
    dec_box_center = ((dec_min.to_f + dec_max.to_f) * 0.5).to_s
    box_width = (ra_max.to_f - ra_min.to_f).to_s
    box_height = (dec_max.to_f - dec_min.to_f).to_s

    <<-END_ADQL
SELECT
    #{@limit}
    *
    FROM #{service[:table_name]}
    WHERE
        1=CONTAINS(POINT('ICRS', #{service[:fields][:ra][:field]}, #{service[:fields][:dec][:field]}),
                   BOX('ICRS', #{ra_box_center}, #{dec_box_center}, #{box_width}, #{box_height}))
#{construct_filter_adql(service)}
    END_ADQL
  end

  def all_fields
    PARAMETER_FIELDS
  end

end