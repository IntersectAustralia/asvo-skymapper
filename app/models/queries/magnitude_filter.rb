class MagnitudeFilter < Query

  FIELDS = [:name, :min, :max]

  attr_accessor *FIELDS

  validates :name, presence: true
  validates :min, numericality: true, format: { with: /^-?\d*(\.\d{1,3})?$/ }, :unless => 'min.blank?'
  validates :max, format: { with: /^-?\d*(\.\d{1,3})?$/ }, :if => '!max.blank?'.to_s
  validates :max, numericality: { greater_than: Proc.new {|q| q.min.to_f } }, :if => '!min.blank? and !max.blank?'
  validate :min_max_presence

  before_validation :clean_values

  def all_fields
    FIELDS
  end

  def min_max_presence
    errors.add :min, 'Must include either min or max' if min.blank? and max.blank?
    errors.add :max, 'Must include either min or max' if min.blank? and max.blank?
  end

end