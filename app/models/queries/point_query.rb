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
    elsif
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
  private
  def ra_format_and_value
    return if self.ra.nil?
    raValue = nil
    format = "^[+]?\\d*(\\.\\d{1,6})?$"
    isDeg = self.ra.match(format)
    if isDeg.nil?
      hourFormat = "^([0-2][0-9])[:\\s]([0-6][0-9])[:\\s]([0-6][0-9])(\\.[0-9]{1,5})?$"
      values = self.ra.match(hourFormat).to_a
      if values.size > 0
        raValue = ((values[1].to_f + values[2].to_f/60 + values[3].to_f/3600) / 24 * 360).round(6)
      end
    elsif self.ra.size > 0
      raValue = self.ra.to_f.round(6)
    end

    #error for format
    errors.add(:ra, 'should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD.') if raValue.nil?
    return if raValue.nil?
    if raValue >= 0 and raValue < 360
      self.ra = raValue.to_s
    else
      errors.add(:ra, 'must be greater than or equal to 0 and less then 360.')
    end
  end

  def dec_format_and_value
    return if self.dec.nil?
    decValue = nil
    format = "^[+-]?\\d*(\\.\\d{1,6})?$"
    isDeg = self.dec.match(format)
    if isDeg.nil?
      hourFormat = "^([+-]?[0-9][0-9])[:\\s]([0-6][0-9])[:\\s]([0-6][0-9])(\\.[0-9]{1,5})?$"
      values = self.dec.match(hourFormat).to_a
      if values.size > 0
        negative = 1
        negative = -1 if values[1].include? ('-')
        decValue = ((values[1].to_f.abs + values[2].to_f / 60 + values[3].to_f / 3600) * negative ).round(6)
      end
    elsif self.dec.size > 0
      decValue = self.dec.to_f.round(6)
    end
    #error for format
    errors.add(:dec, 'should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD.') if decValue.nil?
    return if decValue.nil?
    if decValue >= -90 and decValue <= 90
      self.dec = decValue.to_s
    else
      errors.add(:dec, 'must be greater than or equal to -90 and less then or equal to 90.')
    end
  end
end