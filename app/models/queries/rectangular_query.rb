class RectangularQuery < Query

  ADQL = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM <table_name>
    WHERE
        1=CONTAINS(POINT('ICRS',<ra_field>,<dec_field>),
                   BOX('ICRS',<ra_box_center>,<dec_box_center>,<box_width>,<box_height>))
  END_ADQL

  attr_accessor :table_name, :ra_field, :dec_field, :ra_min, :ra_max, :dec_min, :dec_max

  validates :table_name, presence: true
  validates :ra_field, presence: true
  validates :dec_field, presence: true
  validates :ra_min, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, format: { with: /^-?\d*(\.\d{1,5})?$/ }
  validates :ra_max, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, format: { with: /^-?\d*(\.\d{1,5})?$/ }
  validates :dec_min, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, format: { with: /^-?\d*(\.\d{1,5})?$/ }
  validates :dec_max, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, format: { with: /^-?\d*(\.\d{1,5})?$/ }

  before_validation :clean_values, only: [:ra_min, :ra_max, :dec_min, :dec_max]

  def self.create(args)
    query = RectangularQuery.new
    query.from_args(args)
    query
  end

  def to_args
    args = {
        table_name: table_name,
        ra_field: ra_field,
        dec_field: dec_field,
        ra_box_center: ((ra_min.to_f + ra_max.to_f) * 0.5).to_s,
        dec_box_center: ((dec_min.to_f + dec_max.to_f) * 0.5).to_s,
        box_width: (ra_max.to_f - ra_min.to_f).to_s,
        box_height: (dec_max.to_f - dec_min.to_f).to_s
    }
    args
  end

  def from_args(args)
    self.table_name = args[:table_name]
    self.ra_field = args[:ra_field]
    self.dec_field = args[:dec_field]
    self.ra_min = clean(args[:ra_min])
    self.ra_max = clean(args[:ra_max])
    self.dec_min = clean(args[:dec_min])
    self.dec_max = clean(args[:dec_max])
  end

  def to_adql
    QueryBuilder.new(ADQL, to_args).build
  end

  private

  def clean_values
    self.ra_min = clean(self.ra_min)
    self.ra_max = clean(self.ra_max)
    self.dec_min = clean(self.dec_min)
    self.dec_max = clean(self.dec_max)
  end

end