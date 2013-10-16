require 'spec_helper'

describe VOTableParser do

  it 'Parses empty vo table' do
    vo_table = VOTableParser.parse_xml(File.read(Rails.root.join('spec/fixtures/skymapper_point_query_empty.xml')))
    vo_table.should_not be_nil
  end

  it 'Parses point query results for skymapper catalogue fs' do
    vo_table = VOTableParser.parse_xml(File.read(Rails.root.join('spec/fixtures/skymapper_point_query_1.xml')))
    result_table = YAML.load(File.read(Rails.root.join('spec/fixtures/skymapper_point_query_1.vo')))

    vo_table.eql?(result_table).should be_true
  end

  it 'Parses point query results for skymapper catalogue ms' do
    vo_table = VOTableParser.parse_xml(File.read(Rails.root.join('spec/fixtures/skymapper_point_query_2.xml')))
    result_table = YAML.load(File.read(Rails.root.join('spec/fixtures/skymapper_point_query_2.vo')))

    vo_table.eql?(result_table).should be_true
  end

end