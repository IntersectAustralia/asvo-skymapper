require 'spec_helper'

describe PointQuery do

  # Validate Table Name
  it { should allow_value('public.fs_distilled').for(:table_name) }
  it { should_not allow_value(nil).for(:table_name) }

  # Validate Right Ascension Column Name
  it { should allow_value('mean_ra').for(:ra_column_name) }
  it { should_not allow_value(nil).for(:ra_column_name) }

  # Validate Declination Column Name
  it { should allow_value('mean_dcl').for(:dec_column_name) }
  it { should_not allow_value(nil).for(:dec_column_name) }

  # Validate Right Ascension (RA)
  it { should allow_value('0').for(:ra) }
  it { should allow_value('359.99999').for(:ra) }
  it { should allow_value('123.45678').for(:ra) }

  it { should_not allow_value('-0.00001').for(:ra) }
  it { should_not allow_value('360').for(:ra) }
  it { should_not allow_value('1000').for(:ra) }
  it { should_not allow_value('-1000').for(:ra) }
  it { should_not allow_value('123.456789').for(:ra) }
  it { should_not allow_value(nil).for(:ra) }

  # Validate Declination (DEC)
  it { should allow_value('-90').for(:dec) }
  it { should allow_value('90').for(:dec) }
  it { should allow_value('0').for(:dec) }
  it { should allow_value('12.34567').for(:dec) }
  it { should allow_value('-12.34567').for(:dec) }
  it { should_not allow_value(nil).for(:dec) }

  it { should_not allow_value('-90.0001').for(:dec) }
  it { should_not allow_value('90.0001').for(:dec) }
  it { should_not allow_value('1000').for(:dec) }
  it { should_not allow_value('-1000').for(:dec) }
  it { should_not allow_value('12.3456789').for(:dec) }
  it { should_not allow_value('-12.3456789').for(:dec) }
  it { should_not allow_value(nil).for(:dec) }

  # Validate Search Radius (SR)
  it { should allow_value('0.0001').for(:sr) }
  it { should allow_value('10').for(:sr) }
  it { should allow_value('1.23456789').for(:sr) }

  it { should_not allow_value('0').for(:sr) }
  it { should_not allow_value('10.0001').for(:sr) }
  it { should_not allow_value('1000').for(:sr) }
  it { should_not allow_value('-1000').for(:sr) }
  it { should_not allow_value(nil).for(:sr) }

  it 'Create point query for skymapper catalogue fs' do
    registry = Rails.application.config.asvo_registry
    fs_catalogue = registry.datasets[:skymapper][:catalogues][:fs]

    args = {
        table_name: fs_catalogue[:table_name],
        ra_column_name: fs_catalogue[:ra_column_name],
        dec_column_name: fs_catalogue[:dec_column_name],
        ra: 62.70968,
        dec: -1.18844,
        sr: 0.5
    }

    query = PointQuery.create(args)
    query.valid?.should be_true

    adql = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM #{fs_catalogue[:table_name]}
    WHERE
        1=CONTAINS(POINT('ICRS', #{fs_catalogue[:ra_column_name]}, #{fs_catalogue[:dec_column_name]}),
                   CIRCLE('ICRS', #{args[:ra]}, #{args[:dec]}, #{args[:sr]} ))
    END_ADQL
    query.to_adql.should == adql
  end

end