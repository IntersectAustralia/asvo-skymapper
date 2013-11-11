require 'csv'

class BulkImageQuery < Query

  PARAMETER_FIELDS = [:file, :sr]

  attr_accessor *PARAMETER_FIELDS

  validates :file, presence: true
  validate :file, :search_file_valid

  before_validation :clean_values

  def all_fields
    PARAMETER_FIELDS
  end

end