require 'spec_helper'

describe BulkImageQuery do

  # Validate Search File
  it { should_not allow_value(nil).for(:file) }

  it 'Search file should be a valid csv file' do
    query = BulkImageQuery.new
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_valid_1.csv')
    query.valid?
    query.errors.messages[:file].should be_nil
  end

  it 'Search file headers are case insensitive' do
    query = BulkImageQuery.new
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_valid_2.csv')
    query.valid?
    query.errors.messages[:file].should be_nil
  end

  it 'Search must have valid headers' do
    query = BulkImageQuery.new
    # no headers
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_invalid_5.csv')
    query.valid?
    query.errors.messages[:file].should_not be_nil

    # no dec
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_invalid_6.csv')
    query.valid?
    query.errors.messages[:file].should_not be_nil

    # no ra
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_invalid_7.csv')
    query.valid?
    query.errors.messages[:file].should_not be_nil
  end

  it 'Search file cannot be empty' do
    query = BulkImageQuery.new
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_invalid_1.csv')
    query.valid?
    query.errors.messages[:file].should_not be_nil
  end

  it 'Search file cannot have invalid points' do
    query = BulkImageQuery.new
    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_invalid_2.csv')
    query.valid?
    # RA values
    # '0'
    # '359.999999'
    # '123.123456'
    # '1.123456'
    # '.123456'
    # '   .123456    '
    # '-0.000001'
    # '360'
    # '1000'
    # '-1000'
    # '.1234567'
    # ''
    # '7abc'
    # '.'
    # ' 1.  '
    query.errors.messages[:file].include?('Line 7: Right ascension must be greater than or equal to 0').should be_true
    query.errors.messages[:file].include?('Line 8: Right ascension must be less than 360').should be_true
    query.errors.messages[:file].include?('Line 9: Right ascension must be less than 360').should be_true
    query.errors.messages[:file].include?('Line 10: Right ascension must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?("Line 11: Right ascension can't be blank").should be_true
    query.errors.messages[:file].include?('Line 11: Right ascension is not a number').should be_true
    query.errors.messages[:file].include?('Line 12: Right ascension is not a number').should be_true
    query.errors.messages[:file].include?('Line 12: Right ascension must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?('Line 13: Right ascension is not a number').should be_true
    query.errors.messages[:file].include?('Line 13: Right ascension must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?('Line 14: Right ascension is not a number').should be_true
    query.errors.messages[:file].include?('Line 14: Right ascension must be a number with 6 decimal places').should be_true

    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_invalid_3.csv')
    query.valid?
    # DEC values
    # '-90'
    # '90'
    # '0'
    # '1.123456'
    # '-1.123456'
    # '   -.123456    '
    # '-90.000001'
    # '90.000001'
    # '1000'
    # '-1000'
    # '1.1234567'
    # '-1.1234567'
    # ''
    # '7abc'
    # '.'
    # ' -  1.  '
    query.errors.messages[:file].include?('Line 7: Declination must be greater than or equal to -90').should be_true
    query.errors.messages[:file].include?('Line 8: Declination must be less than or equal to 90').should be_true
    query.errors.messages[:file].include?('Line 9: Declination must be less than or equal to 90').should be_true
    query.errors.messages[:file].include?('Line 10: Declination must be greater than or equal to -90').should be_true
    query.errors.messages[:file].include?('Line 11: Declination must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?('Line 12: Declination must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?("Line 13: Declination can't be blank").should be_true
    query.errors.messages[:file].include?('Line 13: Declination is not a number').should be_true
    query.errors.messages[:file].include?('Line 14: Declination is not a number').should be_true
    query.errors.messages[:file].include?('Line 14: Declination must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?('Line 15: Declination is not a number').should be_true
    query.errors.messages[:file].include?('Line 15: Declination must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?('Line 16: Declination is not a number').should be_true
    query.errors.messages[:file].include?('Line 16: Declination must be a number with 6 decimal places').should be_true

    query.file = Rails.root.join('spec/fixtures/skymapper_bulk_invalid_4.csv')
    query.valid?
    # RA and DEC values
    # see above
    query.errors.messages[:file].include?('Line 7: Right ascension must be greater than or equal to 0').should be_true
    query.errors.messages[:file].include?('Line 8: Right ascension must be less than 360').should be_true
    query.errors.messages[:file].include?('Line 9: Right ascension must be less than 360').should be_true
    query.errors.messages[:file].include?('Line 10: Right ascension must be greater than or equal to 0').should be_true
    query.errors.messages[:file].include?('Line 11: Right ascension must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?("Line 12: Right ascension can't be blank").should be_true
    query.errors.messages[:file].include?('Line 12: Right ascension is not a number').should be_true
    query.errors.messages[:file].include?("Line 13: Right ascension can't be blank").should be_true
    query.errors.messages[:file].include?('Line 13: Right ascension is not a number').should be_true
    query.errors.messages[:file].include?('Line 14: Right ascension is not a number').should be_true
    query.errors.messages[:file].include?('Line 14: Right ascension must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?('Line 15: Right ascension is not a number').should be_true
    query.errors.messages[:file].include?('Line 15: Right ascension must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?('Line 16: Right ascension is not a number').should be_true
    query.errors.messages[:file].include?('Line 16: Right ascension must be a number with 6 decimal places').should be_true

    query.errors.messages[:file].include?('Line 7: Declination must be greater than or equal to -90').should be_true
    query.errors.messages[:file].include?('Line 8: Declination must be less than or equal to 90').should be_true
    query.errors.messages[:file].include?('Line 9: Declination must be less than or equal to 90').should be_true
    query.errors.messages[:file].include?('Line 10: Declination must be greater than or equal to -90').should be_true
    query.errors.messages[:file].include?('Line 11: Declination must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?('Line 12: Declination must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?("Line 13: Declination can't be blank").should be_true
    query.errors.messages[:file].include?('Line 13: Declination is not a number').should be_true
    query.errors.messages[:file].include?('Line 14: Declination is not a number').should be_true
    query.errors.messages[:file].include?('Line 14: Declination must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?('Line 15: Declination is not a number').should be_true
    query.errors.messages[:file].include?('Line 15: Declination must be a number with 6 decimal places').should be_true
    query.errors.messages[:file].include?('Line 16: Declination is not a number').should be_true
    query.errors.messages[:file].include?('Line 16: Declination must be a number with 6 decimal places').should be_true
  end

end