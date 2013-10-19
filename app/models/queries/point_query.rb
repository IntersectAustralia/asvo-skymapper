class PointQuery < Query

  ADQL = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM <table_name>
    WHERE
        1=CONTAINS(POINT('ICRS', <ra_field>, <dec_field>),
                   CIRCLE('ICRS', <ra>, <dec>, <sr> ))
  END_ADQL

  attr_accessor :table_name, :ra_field, :dec_field, :ra, :dec, :sr

  validates :table_name, presence: true
  validates :ra_field, presence: true
  validates :dec_field, presence: true
  validates :ra, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, format: { with: /^-?\d*(\.\d{1,5})?$/ }
  validates :dec, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, format: { with: /^-?\d*(\.\d{1,5})?$/ }
  validates :sr, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 10 }

  before_validation :clean_values, only: [:ra, :dec, :sr]

  def self.create(args)
    query = PointQuery.new
    query.from_args(args)
    query
  end

  def to_args
    args = {
      table_name: table_name,
      ra_field: ra_field,
      dec_field: dec_field,
      ra: ra,
      dec: dec,
      sr: sr
    }
    args
  end

  def from_args(args)
    self.table_name = args[:table_name]
    self.ra_field = args[:ra_field]
    self.dec_field = args[:dec_field]
    self.ra = clean(args[:ra])
    self.dec = clean(args[:dec])
    self.sr = clean(args[:sr])
  end

  def to_adql
    QueryBuilder.new(ADQL, to_args).build
  end

  private

  def clean_values
    self.ra = clean(self.ra)
    self.dec = clean(self.dec)
    self.sr = clean(self.sr)
  end

end