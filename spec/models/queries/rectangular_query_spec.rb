require 'spec_helper'

describe RectangularQuery do

  # Validate Table Name
  it { should allow_value('public.fs_distilled').for(:table_name) }
  it { should_not allow_value(nil).for(:table_name) }
  it { should_not allow_value('').for(:table_name) }

  # Validate Right Ascension Field
  it { should allow_value('mean_ra').for(:ra_field) }
  it { should_not allow_value(nil).for(:ra_field) }
  it { should_not allow_value('').for(:table_name) }

  # Validate Declination Field
  it { should allow_value('mean_dcl').for(:dec_field) }
  it { should_not allow_value(nil).for(:dec_field) }
  it { should_not allow_value('').for(:table_name) }

  # Validate Right Ascension min (RA)
  it { should allow_value('0').for(:ra_min) }
  it { should allow_value('359.99999999').for(:ra_min) }
  it { should allow_value('123.12345678').for(:ra_min) }
  it { should allow_value('1.12345678').for(:ra_min) }
  it { should allow_value('.12345678').for(:ra_min) }
  it { should allow_value('   .12345678    ').for(:ra_min) }

  it { should_not allow_value('-0.00000001').for(:ra_min) }
  it { should_not allow_value('360').for(:ra_min) }
  it { should_not allow_value('1000').for(:ra_min) }
  it { should_not allow_value('-1000').for(:ra_min) }
  it { should_not allow_value('.123456789').for(:ra_min) }
  it { should_not allow_value(nil).for(:ra_min) }
  it { should_not allow_value('').for(:ra_min) }
  it { should_not allow_value('7abc').for(:ra_min) }
  it { should_not allow_value('.').for(:ra_min) }
  it { should_not allow_value(' 1.  ').for(:ra_min) }

  # Validate Right Ascension max (RA)
  it { should allow_value('0').for(:ra_max) }
  it { should allow_value('359.99999999').for(:ra_max) }
  it { should allow_value('123.12345678').for(:ra_max) }
  it { should allow_value('1.12345678').for(:ra_max) }
  it { should allow_value('.12345678').for(:ra_max) }
  it { should allow_value('   .12345678    ').for(:ra_max) }

  it { should_not allow_value('-0.00000001').for(:ra_max) }
  it { should_not allow_value('360').for(:ra_max) }
  it { should_not allow_value('1000').for(:ra_max) }
  it { should_not allow_value('-1000').for(:ra_max) }
  it { should_not allow_value('.123456789').for(:ra_max) }
  it { should_not allow_value(nil).for(:ra_max) }
  it { should_not allow_value('').for(:ra_max) }
  it { should_not allow_value('7abc').for(:ra_max) }
  it { should_not allow_value('.').for(:ra_max) }
  it { should_not allow_value(' 1.  ').for(:ra_max) }

  # Validate Declination min (DEC)
  it { should allow_value('-90').for(:dec_min) }
  it { should allow_value('90').for(:dec_min) }
  it { should allow_value('0').for(:dec_min) }
  it { should allow_value('1.12345678').for(:dec_min) }
  it { should allow_value('-1.12345678').for(:dec_min) }
  it { should allow_value('   -.12345678    ').for(:dec_min) }

  it { should_not allow_value('-90.00000001').for(:dec_min) }
  it { should_not allow_value('90.00000001').for(:dec_min) }
  it { should_not allow_value('1000').for(:dec_min) }
  it { should_not allow_value('-1000').for(:dec_min) }
  it { should_not allow_value('1.123456789').for(:dec_min) }
  it { should_not allow_value('-1.123456789').for(:dec_min) }
  it { should_not allow_value(nil).for(:dec_min) }
  it { should_not allow_value('').for(:dec_min) }
  it { should_not allow_value('7abc').for(:dec_min) }
  it { should_not allow_value('.').for(:dec_min) }
  it { should_not allow_value(' -  1.  ').for(:dec_min) }

  # Validate Declination max (DEC)
  it { should allow_value('-90').for(:dec_max) }
  it { should allow_value('90').for(:dec_max) }
  it { should allow_value('0').for(:dec_max) }
  it { should allow_value('1.12345678').for(:dec_max) }
  it { should allow_value('-1.12345678').for(:dec_max) }
  it { should allow_value('   -.12345678    ').for(:dec_max) }

  it { should_not allow_value('-90.00000001').for(:dec_max) }
  it { should_not allow_value('90.00000001').for(:dec_max) }
  it { should_not allow_value('1000').for(:dec_max) }
  it { should_not allow_value('-1000').for(:dec_max) }
  it { should_not allow_value('1.123456789').for(:dec_max) }
  it { should_not allow_value('-1.123456789').for(:dec_max) }
  it { should_not allow_value(nil).for(:dec_max) }
  it { should_not allow_value('').for(:dec_max) }
  it { should_not allow_value('7abc').for(:dec_max) }
  it { should_not allow_value('.').for(:dec_max) }
  it { should_not allow_value(' -  1.  ').for(:dec_max) }

  # Validate RA max > min
  it 'ra max must be greater than ra min' do
    q = RectangularQuery.new
    q.ra_min = 0
    q.ra_max = 0
    q.valid?
    q.errors[:ra_max].should_not be_empty
    q.ra_max = '-1'
    q.valid?
    q.errors[:ra_max].should_not be_empty
    q.ra_max = '2'
    q.valid?
    q.errors[:ra_max].should be_empty
  end

  # Validate DEC max > min
  it 'dec max must be greater than dec min' do
    q = RectangularQuery.new
    q.dec_min = 0
    q.dec_max = 0
    q.valid?
    q.errors[:dec_max].should_not be_empty
    q.dec_max = '-1'
    q.valid?
    q.errors[:dec_max].should_not be_empty
    q.dec_max = '2'
    q.valid?
    q.errors[:dec_max].should be_empty
  end

  it 'Validate magnitude filters' do

    query = RectangularQuery.new(
        table_name: 'test',
        ra_field: 'test',
        dec_field: 'test',
        ra_min: '1',
        ra_max: '2',
        dec_min: '1',
        dec_max: '2'
    )
    query.valid?.should be_true

    u = MagnitudeFilter.new(field: 'test', min:'1.0', max:'2.0')
    v = MagnitudeFilter.new(field: 'test', min:'1.0', max:'1.0')
    g = MagnitudeFilter.new(field: 'test', min:'1.0', max:'2.0')
    r = MagnitudeFilter.new(field: 'test', min:'1.0', max:'1.0')
    i = MagnitudeFilter.new(field: 'test', min:'1.0', max:'2.0')
    z = MagnitudeFilter.new(field: 'test', min:'1.0', max:'1.0')

    query.filters = []
    query.valid?.should be_true

    query.filters = [u]
    query.valid?.should be_true

    query.filters = [u, g, i]
    query.valid?.should be_true

    query.filters = [u, v, g, r, i, z]
    query.valid?.should be_false

  end

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

    query = RectangularQuery.new(args)
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
        1=CONTAINS(POINT('ICRS', #{catalogue[:fields][:ra_field]}, #{catalogue[:fields][:dec_field]}),
                   BOX('ICRS', #{(ra_min + ra_max) * 0.5}, #{(dec_min + dec_max) * 0.5}, #{(ra_max - ra_min)}, #{dec_max - dec_min}))

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

    query = RectangularQuery.new(args)
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
        1=CONTAINS(POINT('ICRS', #{catalogue[:fields][:ra_field]}, #{catalogue[:fields][:dec_field]}),
                   BOX('ICRS', #{(ra_min + ra_max) * 0.5}, #{(dec_min + dec_max) * 0.5}, #{(ra_max - ra_min)}, #{dec_max - dec_min}))

    END_ADQL
    query.to_adql.should == adql
  end

  it 'Create rectangular query for skymapper using all filters' do
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

    query = RectangularQuery.new(args)

    u = MagnitudeFilter.new(field: catalogue[:fields][:u_field], min:'1.0', max:'2.0')
    v = MagnitudeFilter.new(field: catalogue[:fields][:v_field], min:'2.0', max:'3.0')
    g = MagnitudeFilter.new(field: catalogue[:fields][:g_field], min:'3.0', max:'4.0')
    r = MagnitudeFilter.new(field: catalogue[:fields][:r_field], min:'4.0', max:'5.0')
    i = MagnitudeFilter.new(field: catalogue[:fields][:i_field], min:'5.0', max:'6.0')
    z = MagnitudeFilter.new(field: catalogue[:fields][:z_field], min:'6.0', max:'7.0')

    query.filters = [u, v, g, r, i, z]

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
        1=CONTAINS(POINT('ICRS', #{catalogue[:fields][:ra_field]}, #{catalogue[:fields][:dec_field]}),
                   BOX('ICRS', #{(ra_min + ra_max) * 0.5}, #{(dec_min + dec_max) * 0.5}, #{(ra_max - ra_min)}, #{dec_max - dec_min}))
AND #{catalogue[:fields][:u_field]} >= #{u.min}
AND #{catalogue[:fields][:u_field]} <= #{u.max}
AND #{catalogue[:fields][:v_field]} >= #{v.min}
AND #{catalogue[:fields][:v_field]} <= #{v.max}
AND #{catalogue[:fields][:g_field]} >= #{g.min}
AND #{catalogue[:fields][:g_field]} <= #{g.max}
AND #{catalogue[:fields][:r_field]} >= #{r.min}
AND #{catalogue[:fields][:r_field]} <= #{r.max}
AND #{catalogue[:fields][:i_field]} >= #{i.min}
AND #{catalogue[:fields][:i_field]} <= #{i.max}
AND #{catalogue[:fields][:z_field]} >= #{z.min}
AND #{catalogue[:fields][:z_field]} <= #{z.max}

    END_ADQL
    query.to_adql.should == adql
  end

  it 'Create rectangular query for skymapper catalogue some filters' do
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

    query = RectangularQuery.new(args)

    u = MagnitudeFilter.new(field: catalogue[:fields][:u_field], min:'1.0')
    v = MagnitudeFilter.new(field: catalogue[:fields][:v_field], max:'3.0')
    g = MagnitudeFilter.new(field: catalogue[:fields][:g_field], min:'3.0')
    r = MagnitudeFilter.new(field: catalogue[:fields][:r_field], max:'5.0')
    i = MagnitudeFilter.new(field: catalogue[:fields][:i_field], min:'5.0')
    z = MagnitudeFilter.new(field: catalogue[:fields][:z_field], max:'7.0')

    query.filters = [u, v, g, r, i, z]

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
        1=CONTAINS(POINT('ICRS', #{catalogue[:fields][:ra_field]}, #{catalogue[:fields][:dec_field]}),
                   BOX('ICRS', #{(ra_min + ra_max) * 0.5}, #{(dec_min + dec_max) * 0.5}, #{(ra_max - ra_min)}, #{dec_max - dec_min}))
AND #{catalogue[:fields][:u_field]} >= #{u.min}
AND #{catalogue[:fields][:v_field]} <= #{v.max}
AND #{catalogue[:fields][:g_field]} >= #{g.min}
AND #{catalogue[:fields][:r_field]} <= #{r.max}
AND #{catalogue[:fields][:i_field]} >= #{i.min}
AND #{catalogue[:fields][:z_field]} <= #{z.max}

    END_ADQL
    query.to_adql.should == adql
  end

end