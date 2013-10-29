class VOTableParser

  def self.parse_xml(xml)
    doc = Nokogiri::HTML(xml)

    vo_table = VOTable.new

    vo_table.query_status = doc.xpath('//info[@name="QUERY_STATUS"]').attr('value').value.upcase unless
        doc.xpath('//info[@name="QUERY_STATUS"]').empty?
    vo_table.provider = doc.xpath('//info[@name="PROVIDER"]').text unless
        doc.xpath('//info[@name="PROVIDER"]').empty?
    vo_table.query = doc.xpath('//info[@name="QUERY"]').attr('value').value unless
        doc.xpath('//info[@name="QUERY"]').empty?

    vo_table.pos = doc.xpath('//param[@name="POS"]').attr('value').value unless
        doc.xpath('//param[@name="POS"]').empty?

    vo_table.table_fields = parse_fields(doc)
    vo_table.table_data = parse_data(vo_table.table_fields, doc)

    vo_table
  end

  private

  def self.parse_fields(doc)
    fields = []
    doc.xpath('//table/field').each do |field_node|
      id = field_node.attr('id') if field_node.attr('id')
      name = field_node.attr('name') if field_node.attr('name')
      ucd = field_node.attr('ucd') if field_node.attr('ucd')
      datatype = field_node.attr('datatype') if field_node.attr('datatype')
      unit = field_node.attr('unit') if field_node.attr('unit')
      fields.push(id: id, name: name, ucd: ucd, datatype: datatype, unit: unit)
    end
    fields
  end

  def self.parse_data(fields, doc)
    keys = fields.map { |field| field[:id] }
    
    data = []
    doc.xpath('//tabledata/tr').each do |tr_node|
      entry = {}
      tr_node.xpath('./td').each_with_index do |td_node, index|
        entry[keys[index]] = td_node.text
      end
      data.push(entry)
    end
    data
  end

end