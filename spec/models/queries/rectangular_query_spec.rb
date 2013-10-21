require 'spec_helper'

describe RectangularQuery do

  # Validate Table Name
  it { should allow_value('public.fs_distilled').for(:table_name) }
  it { should_not allow_value(nil).for(:table_name) }

  # Validate Right Ascension Field
  it { should allow_value('mean_ra').for(:ra_field) }
  it { should_not allow_value(nil).for(:ra_field) }

  # Validate Declination Field
  it { should allow_value('mean_dcl').for(:dec_field) }
  it { should_not allow_value(nil).for(:dec_field) }

  # Validate Right Ascension min (RA)
  it { should allow_value('0').for(:ra_min) }
  it { should allow_value('359.99999').for(:ra_min) }
  it { should allow_value('123.45678').for(:ra_min) }
  it { should allow_value(' 1.12345  ').for(:ra_min) }
  it { should allow_value(' .12345  ').for(:ra_min) }

  it { should_not allow_value('-0.00001').for(:ra_min) }
  it { should_not allow_value('360').for(:ra_min) }
  it { should_not allow_value('1000').for(:ra_min) }
  it { should_not allow_value('-1000').for(:ra_min) }
  it { should_not allow_value('123.456789').for(:ra_min) }
  it { should_not allow_value(nil).for(:ra_min) }
  it { should_not allow_value('abc').for(:ra_min) }
  it { should_not allow_value('.').for(:ra_min) }
  it { should_not allow_value(' 1.  ').for(:ra_min) }

  # Validate Right Ascension max (RA)
  it { should allow_value('0').for(:ra_max) }
  it { should allow_value('359.99999').for(:ra_max) }
  it { should allow_value('123.45678').for(:ra_max) }
  it { should allow_value(' 1.12345  ').for(:ra_max) }
  it { should allow_value(' .12345  ').for(:ra_max) }

  it { should_not allow_value('-0.00001').for(:ra_max) }
  it { should_not allow_value('360').for(:ra_max) }
  it { should_not allow_value('1000').for(:ra_max) }
  it { should_not allow_value('-1000').for(:ra_max) }
  it { should_not allow_value('123.456789').for(:ra_max) }
  it { should_not allow_value(nil).for(:ra_max) }
  it { should_not allow_value('abc').for(:ra_max) }
  it { should_not allow_value('.').for(:ra_max) }
  it { should_not allow_value(' 1.  ').for(:ra_min) }

  # Validate Declination min (DEC)
  it { should allow_value('-90').for(:dec_min) }
  it { should allow_value('90').for(:dec_min) }
  it { should allow_value('0').for(:dec_min) }
  it { should allow_value('12.34567').for(:dec_min) }
  it { should allow_value('-12.34567').for(:dec_min) }
  it { should allow_value(' -  1.12345  ').for(:dec_min) }
  it { should allow_value(' -  .12345  ').for(:dec_min) }

  it { should_not allow_value(nil).for(:dec_min) }
  it { should_not allow_value('-90.0001').for(:dec_min) }
  it { should_not allow_value('90.0001').for(:dec_min) }
  it { should_not allow_value('1000').for(:dec_min) }
  it { should_not allow_value('-1000').for(:dec_min) }
  it { should_not allow_value('12.3456789').for(:dec_min) }
  it { should_not allow_value('-12.3456789').for(:dec_min) }
  it { should_not allow_value(nil).for(:dec_min) }
  it { should_not allow_value('abc').for(:dec_min) }
  it { should_not allow_value('.').for(:dec_min) }
  it { should_not allow_value(' -  1.  ').for(:dec_min) }

  # Validate Declination max (DEC)
  it { should allow_value('-90').for(:dec_max) }
  it { should allow_value('90').for(:dec_max) }
  it { should allow_value('0').for(:dec_max) }
  it { should allow_value('12.34567').for(:dec_max) }
  it { should allow_value('-12.34567').for(:dec_max) }
  it { should allow_value(' -  1.12345  ').for(:dec_max) }
  it { should allow_value(' -  .12345  ').for(:dec_max) }

  it { should_not allow_value(nil).for(:dec_max) }
  it { should_not allow_value('-90.0001').for(:dec_max) }
  it { should_not allow_value('90.0001').for(:dec_max) }
  it { should_not allow_value('1000').for(:dec_max) }
  it { should_not allow_value('-1000').for(:dec_max) }
  it { should_not allow_value('12.3456789').for(:dec_max) }
  it { should_not allow_value('-12.3456789').for(:dec_max) }
  it { should_not allow_value(nil).for(:dec_max) }
  it { should_not allow_value('abc').for(:dec_max) }
  it { should_not allow_value('.').for(:dec_max) }
  it { should_not allow_value(' -  1.  ').for(:dec_max) }

  it 'Create rectangular query for skymapper catalogue fs' do
    registry = Rails.application.config.asvo_registry
    catalogue = registry.find_catalogue('skymapper', 'fs')

    args = {
        table_name: catalogue[:table_name],
        ra_field: catalogue[:fields][:ra_field],
        dec_field: catalogue[:fields][:dec_field],
        ra_min: '178.83871',
        ra_max: '300',
        dec_min: '-1.18844',
        dec_max: '50.31'
    }

    query = RectangularQuery.create(args)
    query.valid?.should be_true

    ra_min = args[:ra_min].to_f
    ra_max = args[:ra_max].to_f
    dec_min = args[:dec_min].to_f
    dec_max = args[:dec_max].to_f

    adql = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM #{catalogue[:table_name]}
    WHERE
        1=CONTAINS(POINT('ICRS',#{catalogue[:fields][:ra_field]},#{catalogue[:fields][:dec_field]}),
                   BOX('ICRS',#{(ra_min + ra_max) * 0.5},#{(dec_min + dec_max) * 0.5},#{(ra_max - ra_min)},#{dec_max - dec_min}))
    END_ADQL
    query.to_adql.should == adql
  end

  it 'Create rectangular query for skymapper catalogue ms' do
    registry = Rails.application.config.asvo_registry
    catalogue = registry.find_catalogue('skymapper', 'ms')

    args = {
        table_name: catalogue[:table_name],
        ra_field: catalogue[:fields][:ra_field],
        dec_field: catalogue[:fields][:dec_field],
        ra_min: '178.83871',
        ra_max: '300',
        dec_min: '-1.18844',
        dec_max: '50.31'
    }

    query = RectangularQuery.create(args)
    query.valid?.should be_true

    ra_min = args[:ra_min].to_f
    ra_max = args[:ra_max].to_f
    dec_min = args[:dec_min].to_f
    dec_max = args[:dec_max].to_f

    adql = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM #{catalogue[:table_name]}
    WHERE
        1=CONTAINS(POINT('ICRS',#{catalogue[:fields][:ra_field]},#{catalogue[:fields][:dec_field]}),
                   BOX('ICRS',#{(ra_min + ra_max) * 0.5},#{(dec_min + dec_max) * 0.5},#{(ra_max - ra_min)},#{dec_max - dec_min}))
    END_ADQL
    query.to_adql.should == adql
  end

end