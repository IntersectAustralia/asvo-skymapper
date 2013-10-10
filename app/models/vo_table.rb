class VOTable

  attr_accessor :query_status, :provider, :query, :table_fields, :table_data

  def eql?(vo_table)
    self.query_status == vo_table.query_status and
        self.provider == vo_table.provider and
        self.query == vo_table.query and
        self.table_fields == vo_table.table_fields and
        self.table_data == vo_table.table_data
  end

end