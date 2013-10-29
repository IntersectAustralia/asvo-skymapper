class VOTable

  attr_accessor :query_status, :provider, :query # radial and rectangular fields
  attr_accessor :pos # image fields
  attr_accessor :table_fields, :table_data # common fields

  def empty?
    self.to_array.select { |x| !nil_or_empty? x }.empty?
  end

  def eql?(vo_table)
    self.to_array == vo_table.to_array
  end

  def to_array
    [
        self.table_fields,
        self.table_data
    ]
  end

  private

  def nil_or_empty?(obj)
    obj.nil? or obj.empty?
  end

end