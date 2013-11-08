require 'spec_helper'

describe BulkCatalogueQuery do

  # Validate Search Radius (SR)
  it { should allow_value('0.00000001').for(:sr) }
  it { should allow_value('0.05').for(:sr) }
  it { should allow_value('0.01234567').for(:sr) }
  it { should allow_value('.01234567').for(:sr) }
  it { should allow_value('   .01234567    ').for(:sr) }

  it { should_not allow_value('0').for(:sr) }
  it { should_not allow_value('0.05000001').for(:sr) }
  it { should_not allow_value('1000').for(:sr) }
  it { should_not allow_value('-1000').for(:sr) }
  it { should_not allow_value('.012345678').for(:sr) }
  it { should_not allow_value(nil).for(:sr) }
  it { should_not allow_value('').for(:sr) }
  it { should_not allow_value('7abc').for(:sr) }
  it { should_not allow_value('.').for(:sr) }
  it { should_not allow_value('  0.  ').for(:sr) }

  # Validate Search File
  it { should_not allow_value(nil).for(:file) }

  it 'Search file should be a valid csv file' do
    query = BulkCatalogueQuery.new
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_catalogue_valid_1.csv')
    query.valid?
    query.errors.messages[:file].should be_nil
  end

  it 'Search file headers are case insensitive' do
    query = BulkCatalogueQuery.new
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_catalogue_valid_2.csv')
    query.valid?
    query.errors.messages[:file].should be_nil
  end

  it 'Search must have valid headers' do
    query = BulkCatalogueQuery.new
    # no headers
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_catalogue_invalid_5.csv')
    query.valid?
    query.errors.messages[:file].should_not be_nil

    # no dec
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_catalogue_invalid_6.csv')
    query.valid?
    query.errors.messages[:file].should_not be_nil

    # no ra
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_catalogue_invalid_7.csv')
    query.valid?
    query.errors.messages[:file].should_not be_nil
  end

  it 'Search file cannot be empty' do
    query = BulkCatalogueQuery.new
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_catalogue_invalid_1.csv')
    query.valid?
    query.errors.messages[:file].should_not be_nil
  end

  it 'Search file cannot have invalid points' do
    query = BulkCatalogueQuery.new
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_catalogue_invalid_2.csv')
    query.valid?
    # RA values
    # '0' 
    # '359.99999999' 
    # '123.12345678' 
    # '1.12345678' 
    # '.12345678' 
    # '   .12345678    ' 
    # '-0.00000001' 
    # '360' 
    # '1000' 
    # '-1000' 
    # '.123456789' 
    # '' 
    # '7abc' 
    # '.' 
    # ' 1.  ' 
    query.errors.messages[:file].include?('Line 7: Right ascension must be greater than or equal to 0')
    query.errors.messages[:file].include?('Line 8: Right ascension must be less than 360')
    query.errors.messages[:file].include?('Line 9: Right ascension must be less than 360')
    query.errors.messages[:file].include?('Line 10: Right ascension must be greater than or equal to 0')
    query.errors.messages[:file].include?('Line 11: Right ascension must be a number with 8 decimal places')
    query.errors.messages[:file].include?("Line 12: Right ascension can't be blank")
    query.errors.messages[:file].include?('Line 12: Right ascension is not a number')
    query.errors.messages[:file].include?('Line 13: Right ascension is not a number')
    query.errors.messages[:file].include?('Line 13: Right ascension must be a number with 8 decimal places')
    query.errors.messages[:file].include?('Line 14: Right ascension is not a number')
    query.errors.messages[:file].include?('Line 14: Right ascension must be a number with 8 decimal places')
    query.errors.messages[:file].include?('Line 15: Right ascension is not a number')
    query.errors.messages[:file].include?('Line 15: Right ascension must be a number with 8 decimal places')

    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_catalogue_invalid_3.csv')
    query.valid?
    # DEC values
    # '-90' 
    # '90' 
    # '0' 
    # '1.12345678' 
    # '-1.12345678' 
    # '   -.12345678    ' 
    # '-90.00000001' 
    # '90.00000001' 
    # '1000' 
    # '-1000' 
    # '1.123456789' 
    # '-1.123456789' 
    # '' 
    # '7abc' 
    # '.' 
    # ' -  1.  ' 
    query.errors.messages[:file].include?('Line 7: Declination must be greater than or equal to -90')
    query.errors.messages[:file].include?('Line 8: Declination must be less than or equal to 90')
    query.errors.messages[:file].include?('Line 9: Declination must be less than or equal to 90')
    query.errors.messages[:file].include?('Line 10: Declination must be greater than or equal to -90')
    query.errors.messages[:file].include?('Line 11: Declination must be a number with 8 decimal places')
    query.errors.messages[:file].include?('Line 12: Declination must be a number with 8 decimal places')
    query.errors.messages[:file].include?("Line 13: Declination can't be blank")
    query.errors.messages[:file].include?('Line 13: Declination is not a number')
    query.errors.messages[:file].include?('Line 14: Declination is not a number')
    query.errors.messages[:file].include?('Line 14: Declination must be a number with 8 decimal places')
    query.errors.messages[:file].include?('Line 15: Declination is not a number')
    query.errors.messages[:file].include?('Line 15: Declination must be a number with 8 decimal places')
    query.errors.messages[:file].include?('Line 16: Declination is not a number')
    query.errors.messages[:file].include?('Line 16: Declination must be a number with 8 decimal places')

    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_catalogue_invalid_4.csv')
    query.valid?
    # RA and DEC values
    # see above
    query.errors.messages[:file].include?('Line 7: Right ascension must be greater than or equal to 0')
    query.errors.messages[:file].include?('Line 8: Right ascension must be less than 360')
    query.errors.messages[:file].include?('Line 9: Right ascension must be less than 360')
    query.errors.messages[:file].include?('Line 10: Right ascension must be greater than or equal to 0')
    query.errors.messages[:file].include?('Line 11: Right ascension must be a number with 8 decimal places')
    query.errors.messages[:file].include?("Line 12: Right ascension can't be blank")
    query.errors.messages[:file].include?('Line 12: Right ascension is not a number')
    query.errors.messages[:file].include?('Line 14: Right ascension is not a number')
    query.errors.messages[:file].include?('Line 14: Right ascension must be a number with 8 decimal places')
    query.errors.messages[:file].include?('Line 15: Right ascension is not a number')
    query.errors.messages[:file].include?('Line 15: Right ascension must be a number with 8 decimal places')
    query.errors.messages[:file].include?('Line 16: Right ascension is not a number')
    query.errors.messages[:file].include?('Line 16: Right ascension must be a number with 8 decimal places')

    query.errors.messages[:file].include?('Line 7: Declination must be greater than or equal to -90')
    query.errors.messages[:file].include?('Line 8: Declination must be less than or equal to 90')
    query.errors.messages[:file].include?('Line 9: Declination must be less than or equal to 90')
    query.errors.messages[:file].include?('Line 10: Declination must be greater than or equal to -90')
    query.errors.messages[:file].include?('Line 11: Declination must be a number with 8 decimal places')
    query.errors.messages[:file].include?('Line 12: Declination must be a number with 8 decimal places')
    query.errors.messages[:file].include?("Line 13: Declination can't be blank")
    query.errors.messages[:file].include?('Line 13: Declination is not a number')
    query.errors.messages[:file].include?('Line 14: Declination is not a number')
    query.errors.messages[:file].include?('Line 14: Declination must be a number with 8 decimal places')
    query.errors.messages[:file].include?('Line 15: Declination is not a number')
    query.errors.messages[:file].include?('Line 15: Declination must be a number with 8 decimal places')
    query.errors.messages[:file].include?('Line 16: Declination is not a number')
    query.errors.messages[:file].include?('Line 16: Declination must be a number with 8 decimal places')
  end

  it 'Create bulk catalogue query for skymapper service fs' do
    registry = Rails.application.config.asvo_registry
    service = registry.find_service('skymapper', 'fs', 'tap')

    args = {
        file: Rails.root.join('spec/fixtures/skymapper_bulk_catalogue_valid_1.csv'),
        sr: '0.05'
    }

    query = BulkCatalogueQuery.new(args)
    query.valid?.should be_true

    adql = <<-END_ADQL
SELECT
    *
    FROM #{service[:table_name]}
    WHERE
1=CONTAINS(POINT('ICRS', #{service[:fields][:ra][:field]}, #{service[:fields][:dec][:field]}), CIRCLE('ICRS', 178.83871, -1.18844, 0.05))
OR
1=CONTAINS(POINT('ICRS', #{service[:fields][:ra][:field]}, #{service[:fields][:dec][:field]}), CIRCLE('ICRS', 179.83871, -1.18844, 0.05))

    END_ADQL

    query.to_adql(service).should == adql
  end

  it 'Create bulk catalogue query for skymapper service ms' do
    registry = Rails.application.config.asvo_registry
    service = registry.find_service('skymapper', 'ms', 'tap')

    args = {
        file: Rails.root.join('spec/fixtures/skymapper_bulk_catalogue_valid_1.csv'),
        sr: '0.05'
    }

    query = BulkCatalogueQuery.new(args)
    query.valid?.should be_true

    adql = <<-END_ADQL
SELECT
    *
    FROM #{service[:table_name]}
    WHERE
1=CONTAINS(POINT('ICRS', #{service[:fields][:ra][:field]}, #{service[:fields][:dec][:field]}), CIRCLE('ICRS', 178.83871, -1.18844, 0.05))
OR
1=CONTAINS(POINT('ICRS', #{service[:fields][:ra][:field]}, #{service[:fields][:dec][:field]}), CIRCLE('ICRS', 179.83871, -1.18844, 0.05))

    END_ADQL

    query.to_adql(service).should == adql
  end

end