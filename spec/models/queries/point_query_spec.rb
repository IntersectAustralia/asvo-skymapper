require 'spec_helper'

describe PointQuery do

  # Validate Right Ascension (RA)
  it { should allow_value('0').for(:ra) }
  it { should allow_value('359.99999999').for(:ra) }
  it { should allow_value('123.12345678').for(:ra) }
  it { should allow_value('1.12345678').for(:ra) }
  it { should allow_value('.12345678').for(:ra) }
  it { should allow_value('   .12345678    ').for(:ra) }

  it { should_not allow_value('-0.00000001').for(:ra) }
  it { should_not allow_value('360').for(:ra) }
  it { should_not allow_value('1000').for(:ra) }
  it { should_not allow_value('-1000').for(:ra) }
  it { should_not allow_value('.123456789').for(:ra) }
  it { should_not allow_value(nil).for(:ra) }
  it { should_not allow_value('').for(:ra) }
  it { should_not allow_value('7abc').for(:ra) }
  it { should_not allow_value('.').for(:ra) }
  it { should_not allow_value(' 1.  ').for(:ra) }

  # Validate Declination (DEC)
  it { should allow_value('-90').for(:dec) }
  it { should allow_value('90').for(:dec) }
  it { should allow_value('0').for(:dec) }
  it { should allow_value('1.12345678').for(:dec) }
  it { should allow_value('-1.12345678').for(:dec) }
  it { should allow_value('   -.12345678    ').for(:dec) }

  it { should_not allow_value('-90.00000001').for(:dec) }
  it { should_not allow_value('90.00000001').for(:dec) }
  it { should_not allow_value('1000').for(:dec) }
  it { should_not allow_value('-1000').for(:dec) }
  it { should_not allow_value('1.123456789').for(:dec) }
  it { should_not allow_value('-1.123456789').for(:dec) }
  it { should_not allow_value(nil).for(:dec) }
  it { should_not allow_value('').for(:dec) }
  it { should_not allow_value('7abc').for(:dec) }
  it { should_not allow_value('.').for(:dec) }
  it { should_not allow_value(' -  1.  ').for(:dec) }

  # Validate Search Radius (SR)
  it { should allow_value('0.00000001').for(:sr) }
  it { should allow_value('10').for(:sr) }
  it { should allow_value('1.12345678').for(:sr) }
  it { should allow_value('.12345678').for(:sr) }
  it { should allow_value('   .12345678    ').for(:sr) }

  it { should_not allow_value('0').for(:sr) }
  it { should_not allow_value('10.00000001').for(:sr) }
  it { should_not allow_value('1000').for(:sr) }
  it { should_not allow_value('-1000').for(:sr) }
  it { should_not allow_value('.123456789').for(:sr) }
  it { should_not allow_value(nil).for(:sr) }
  it { should_not allow_value('').for(:sr) }
  it { should_not allow_value('7abc').for(:sr) }
  it { should_not allow_value('.').for(:sr) }
  it { should_not allow_value('  1.  ').for(:sr) }

  it 'Validate magnitude filters' do

    query = PointQuery.new(
        table_name: 'test',
        ra_field: 'test',
        dec_field: 'test',
        ra: '1',
        dec: '1',
        sr: '1'
    )
    query.valid?.should be_true

    u = MagnitudeFilter.new(name: 'test', min:'1.0', max:'2.0')
    v = MagnitudeFilter.new(name: 'test', min:'1.0', max:'1.0')
    g = MagnitudeFilter.new(name: 'test', min:'1.0', max:'2.0')
    r = MagnitudeFilter.new(name: 'test', min:'1.0', max:'1.0')
    i = MagnitudeFilter.new(name: 'test', min:'1.0', max:'2.0')
    z = MagnitudeFilter.new(name: 'test', min:'1.0', max:'1.0')

    query.filters = []
    query.valid?.should be_true

    query.filters = [u]
    query.valid?.should be_true

    query.filters = [u, g, i]
    query.valid?.should be_true

    query.filters = [u, v, g, r, i, z]
    query.valid?.should be_false

  end

  it 'Create point query for skymapper service fs' do
    registry = Rails.application.config.asvo_registry
    service = registry.find_service('skymapper', 'ms', 'tap')

    args = {
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }

    query = PointQuery.new(args)
    query.valid?.should be_true

    adql = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM #{service[:table_name]}
    WHERE
        1=CONTAINS(POINT('ICRS', #{service[:fields][:ra_field][:field]}, #{service[:fields][:dec_field][:field]}),
                   CIRCLE('ICRS', #{args[:ra]}, #{args[:dec]}, #{args[:sr]}))

    END_ADQL

    query.to_adql(service).should == adql
  end

  it 'Create point query for skymapper service ms' do
    registry = Rails.application.config.asvo_registry
    service = registry.find_service('skymapper', 'ms', 'tap')

    args = {
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }

    query = PointQuery.new(args)
    query.valid?.should be_true

    adql = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM #{service[:table_name]}
    WHERE
        1=CONTAINS(POINT('ICRS', #{service[:fields][:ra_field][:field]}, #{service[:fields][:dec_field][:field]}),
                   CIRCLE('ICRS', #{args[:ra]}, #{args[:dec]}, #{args[:sr]}))

    END_ADQL
    query.to_adql(service).should == adql
  end

  it 'Create point query for skymapper using all filters' do
    registry = Rails.application.config.asvo_registry
    service = registry.find_service('skymapper', 'fs', 'tap')

    args = {
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }

    query = PointQuery.new(args)

    u = MagnitudeFilter.new(name: 'u', min:'1.0', max:'2.0')
    v = MagnitudeFilter.new(name: 'v', min:'2.0', max:'3.0')
    g = MagnitudeFilter.new(name: 'g', min:'3.0', max:'4.0')
    r = MagnitudeFilter.new(name: 'r', min:'4.0', max:'5.0')
    i = MagnitudeFilter.new(name: 'i', min:'5.0', max:'6.0')
    z = MagnitudeFilter.new(name: 'z', min:'6.0', max:'7.0')

    query.filters = [u, v, g, r, i, z]

    query.valid?.should be_true

    adql = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM #{service[:table_name]}
    WHERE
        1=CONTAINS(POINT('ICRS', #{service[:fields][:ra_field][:field]}, #{service[:fields][:dec_field][:field]}),
                   CIRCLE('ICRS', #{args[:ra]}, #{args[:dec]}, #{args[:sr]}))
AND #{service[:fields][:u_field][:field]} >= #{u.min}
AND #{service[:fields][:u_field][:field]} <= #{u.max}
AND #{service[:fields][:v_field][:field]} >= #{v.min}
AND #{service[:fields][:v_field][:field]} <= #{v.max}
AND #{service[:fields][:g_field][:field]} >= #{g.min}
AND #{service[:fields][:g_field][:field]} <= #{g.max}
AND #{service[:fields][:r_field][:field]} >= #{r.min}
AND #{service[:fields][:r_field][:field]} <= #{r.max}
AND #{service[:fields][:i_field][:field]} >= #{i.min}
AND #{service[:fields][:i_field][:field]} <= #{i.max}
AND #{service[:fields][:z_field][:field]} >= #{z.min}
AND #{service[:fields][:z_field][:field]} <= #{z.max}

    END_ADQL
    query.to_adql(service).should == adql
  end

  it 'Create point query for skymapper service some filters' do
    registry = Rails.application.config.asvo_registry
    service = registry.find_service('skymapper', 'fs', 'tap')

    args = {
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }

    query = PointQuery.new(args)

    u = MagnitudeFilter.new(name: 'u', min:'1.0')
    v = MagnitudeFilter.new(name: 'v', max:'3.0')
    g = MagnitudeFilter.new(name: 'g', min:'3.0')
    r = MagnitudeFilter.new(name: 'r', max:'5.0')
    i = MagnitudeFilter.new(name: 'i', min:'5.0')
    z = MagnitudeFilter.new(name: 'z', max:'7.0')

    query.filters = [u, v, g, r, i, z]

    query.valid?.should be_true

    adql = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM #{service[:table_name]}
    WHERE
        1=CONTAINS(POINT('ICRS', #{service[:fields][:ra_field][:field]}, #{service[:fields][:dec_field][:field]}),
                   CIRCLE('ICRS', #{args[:ra]}, #{args[:dec]}, #{args[:sr]}))
AND #{service[:fields][:u_field][:field]} >= #{u.min}
AND #{service[:fields][:v_field][:field]} <= #{v.max}
AND #{service[:fields][:g_field][:field]} >= #{g.min}
AND #{service[:fields][:r_field][:field]} <= #{r.max}
AND #{service[:fields][:i_field][:field]} >= #{i.min}
AND #{service[:fields][:z_field][:field]} <= #{z.max}

    END_ADQL
    query.to_adql(service).should == adql
  end

end