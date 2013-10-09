class PointQuery < Query

  ADQL = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM <table_name>
    WHERE
        1=CONTAINS(POINT('ICRS', <ra_column_name>, <dec_column_name>),
                   CIRCLE('ICRS', <ra>, <dec>, <sr> ))
  END_ADQL

  attr_accessor :table_name, :ra_column_name, :dec_column_name, :ra, :dec, :sr

  validates :table_name, presence: true
  validates :ra_column_name, presence: true
  validates :dec_column_name, presence: true
  validates :ra, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 360 }, format: { with: /^\d+??(?:\.\d{0,5})?$/ }
  validates :dec, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, format: { with: /^-?\d+??(?:\.\d{0,5})?$/ }
  validates :sr, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 10 }

  def self.create(args)
    query = PointQuery.new
    query.from_args(args)
    query
  end

  def to_args
    args = {
      table_name: table_name,
      ra_column_name: ra_column_name,
      dec_column_name: dec_column_name,
      ra: ra,
      dec: dec,
      sr: sr
    }
    args
  end

  def from_args(args)
    self.table_name = args[:table_name]
    self.ra_column_name = args[:ra_column_name]
    self.dec_column_name = args[:dec_column_name]
    self.ra = args[:ra]
    self.dec = args[:dec]
    self.sr = args[:sr]
  end

  def to_adql
    QueryBuilder.new(ADQL, to_args).build
  end

end