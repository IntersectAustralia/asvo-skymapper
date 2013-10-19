require 'spec_helper'

describe PointQuery do

  # Validate Table Name
  it { should allow_value('public.fs_distilled').for(:table_name) }
  it { should_not allow_value(nil).for(:table_name) }

  # Validate Right Ascension Field
  it { should allow_value('mean_ra').for(:ra_field) }
  it { should_not allow_value(nil).for(:ra_field) }

  # Validate Declination Field
  it { should allow_value('mean_dcl').for(:dec_field) }
  it { should_not allow_value(nil).for(:dec_field) }

  # Validate Right Ascension (RA)
  it { should allow_value('0').for(:ra) }
  it { should allow_value('359.99999').for(:ra) }
  it { should allow_value('123.45678').for(:ra) }
  it { should allow_value(' 1.12345  ').for(:ra) }
  it { should allow_value(' .12345  ').for(:ra) }

  it { should_not allow_value('-0.00001').for(:ra) }
  it { should_not allow_value('360').for(:ra) }
  it { should_not allow_value('1000').for(:ra) }
  it { should_not allow_value('-1000').for(:ra) }
  it { should_not allow_value('123.456789').for(:ra) }
  it { should_not allow_value(nil).for(:ra) }
  it { should_not allow_value('abc').for(:ra) }
  it { should_not allow_value('.').for(:ra) }
  it { should_not allow_value(' 1.  ').for(:ra) }

  # Validate Declination (DEC)
  it { should allow_value('-90').for(:dec) }
  it { should allow_value('90').for(:dec) }
  it { should allow_value('0').for(:dec) }
  it { should allow_value('12.34567').for(:dec) }
  it { should allow_value('-12.34567').for(:dec) }
  it { should allow_value(' -  1.12345  ').for(:dec) }
  it { should allow_value(' -  .12345  ').for(:dec) }

  it { should_not allow_value(nil).for(:dec) }
  it { should_not allow_value('-90.0001').for(:dec) }
  it { should_not allow_value('90.0001').for(:dec) }
  it { should_not allow_value('1000').for(:dec) }
  it { should_not allow_value('-1000').for(:dec) }
  it { should_not allow_value('12.3456789').for(:dec) }
  it { should_not allow_value('-12.3456789').for(:dec) }
  it { should_not allow_value(nil).for(:dec) }
  it { should_not allow_value('abc').for(:dec) }
  it { should_not allow_value('.').for(:dec) }
  it { should_not allow_value(' -  1.  ').for(:dec) }

  # Validate Search Radius (SR)
  it { should allow_value('0.0001').for(:sr) }
  it { should allow_value('10').for(:sr) }
  it { should allow_value('1.23456789').for(:sr) }
  it { should allow_value('  1.12345  ').for(:sr) }
  it { should allow_value('  .12345  ').for(:sr) }

  it { should_not allow_value('0').for(:sr) }
  it { should_not allow_value('10.0001').for(:sr) }
  it { should_not allow_value('1000').for(:sr) }
  it { should_not allow_value('-1000').for(:sr) }
  it { should_not allow_value(nil).for(:sr) }
  it { should_not allow_value('abc').for(:sr) }
  it { should_not allow_value('.').for(:sr) }
  it { should_not allow_value('  1.  ').for(:sr) }

  it 'Create point query for skymapper catalogue fs' do
    registry = Rails.application.config.asvo_registry
    catalogue = registry.find_catalogue('skymapper', 'fs')

    args = {
        table_name: catalogue[:table_name],
        ra_field: catalogue[:fields][:ra_field],
        dec_field: catalogue[:fields][:dec_field],
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }

    query = PointQuery.create(args)
    query.valid?.should be_true

    adql = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM #{catalogue[:table_name]}
    WHERE
        1=CONTAINS(POINT('ICRS', #{catalogue[:fields][:ra_field]}, #{catalogue[:fields][:dec_field]}),
                   CIRCLE('ICRS', #{args[:ra]}, #{args[:dec]}, #{args[:sr]} ))
    END_ADQL
    query.to_adql.should == adql
  end

  it 'Create point query for skymapper catalogue ms' do
    registry = Rails.application.config.asvo_registry
    catalogue = registry.find_catalogue('skymapper', 'ms')

    args = {
        table_name: catalogue[:table_name],
        ra_field: catalogue[:fields][:ra_field],
        dec_field: catalogue[:fields][:dec_field],
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }

    query = PointQuery.create(args)
    query.valid?.should be_true

    adql = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM #{catalogue[:table_name]}
    WHERE
        1=CONTAINS(POINT('ICRS', #{catalogue[:fields][:ra_field]}, #{catalogue[:fields][:dec_field]}),
                   CIRCLE('ICRS', #{args[:ra]}, #{args[:dec]}, #{args[:sr]} ))
    END_ADQL
    query.to_adql.should == adql
  end

end