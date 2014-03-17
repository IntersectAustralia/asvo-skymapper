require 'spec_helper'

describe PointQuery do

  # Validate Right Ascension (RA)
  it { should allow_value('0').for(:ra) }
  it { should allow_value('359.999999').for(:ra) }
  it { should allow_value('123.123456').for(:ra) }
  it { should allow_value('1.123456').for(:ra) }
  it { should allow_value('.123456').for(:ra) }
  it { should allow_value('   .123456    ').for(:ra) }
  it { should allow_value('00:00:00').for(:ra) }
  it { should allow_value('00 00 00').for(:ra) }
  it { should allow_value('23:59:59.1').for(:ra) }
  it { should allow_value('23 59 59.1').for(:ra) }
  it { should allow_value('23:59:59.123').for(:ra) }

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
  it { should_not allow_value('-00:00:01').for(:ra) }
  it { should_not allow_value('-00 00 01').for(:ra) }
  it { should_not allow_value('24:59:59.1').for(:ra) }
  it { should_not allow_value('24 00 00.1').for(:ra) }
  it { should_not allow_value('24:00:00.123').for(:ra) }


  # Validate Declination (DEC)
  it { should allow_value('-90').for(:dec) }
  it { should allow_value('90').for(:dec) }
  it { should allow_value('0').for(:dec) }
  it { should allow_value('-90:00:00').for(:dec) }
  it { should allow_value('90:00:00').for(:dec) }
  it { should allow_value('-00:00:00').for(:dec) }
  it { should allow_value('-90 00 00').for(:dec) }
  it { should allow_value('90 00 00.00').for(:dec) }
  it { should allow_value('00 00 00').for(:dec) }
  it { should allow_value('00:00:00.12').for(:dec) }

  it { should allow_value('1.123456').for(:dec) }
  it { should allow_value('-1.123456').for(:dec) }
  it { should allow_value('   -.123456    ').for(:dec) }

  it { should_not allow_value('-90.00000001').for(:dec) }
  it { should_not allow_value('90.00000001').for(:dec) }
  it { should_not allow_value('1000').for(:dec) }
  it { should_not allow_value('-1000').for(:dec) }
  it { should_not allow_value('-91:00:00.1').for(:dec) }
  it { should_not allow_value('91:00:00.01').for(:dec) }
  it { should_not allow_value('100:00:00').for(:dec) }
  it { should_not allow_value('-100:00:00').for(:dec) }
  it { should_not allow_value('-1000').for(:dec) }
  it { should_not allow_value('1.123456789').for(:dec) }
  it { should_not allow_value('-1.123456789').for(:dec) }
  it { should_not allow_value(nil).for(:dec) }
  it { should_not allow_value('').for(:dec) }
  it { should_not allow_value('7abc').for(:dec) }
  it { should_not allow_value('.').for(:dec) }
  it { should_not allow_value(' -  1.  ').for(:dec) }

  # Validate Search Radius (SR)
  it { should allow_value('0.000001').for(:sr) }
  it { should allow_value('10').for(:sr) }
  it { should allow_value('1.123456').for(:sr) }
  it { should allow_value('.123456').for(:sr) }
  it { should allow_value('   .123456    ').for(:sr) }

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
        1=CONTAINS(POINT('ICRS', #{service[:fields][:ra][:field]}, #{service[:fields][:dec][:field]}),
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
        1=CONTAINS(POINT('ICRS', #{service[:fields][:ra][:field]}, #{service[:fields][:dec][:field]}),
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
        1=CONTAINS(POINT('ICRS', #{service[:fields][:ra][:field]}, #{service[:fields][:dec][:field]}),
                   CIRCLE('ICRS', #{args[:ra]}, #{args[:dec]}, #{args[:sr]}))
AND #{service[:fields][:u][:field]} >= #{u.min}
AND #{service[:fields][:u][:field]} <= #{u.max}
AND #{service[:fields][:v][:field]} >= #{v.min}
AND #{service[:fields][:v][:field]} <= #{v.max}
AND #{service[:fields][:g][:field]} >= #{g.min}
AND #{service[:fields][:g][:field]} <= #{g.max}
AND #{service[:fields][:r][:field]} >= #{r.min}
AND #{service[:fields][:r][:field]} <= #{r.max}
AND #{service[:fields][:i][:field]} >= #{i.min}
AND #{service[:fields][:i][:field]} <= #{i.max}
AND #{service[:fields][:z][:field]} >= #{z.min}
AND #{service[:fields][:z][:field]} <= #{z.max}

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
        1=CONTAINS(POINT('ICRS', #{service[:fields][:ra][:field]}, #{service[:fields][:dec][:field]}),
                   CIRCLE('ICRS', #{args[:ra]}, #{args[:dec]}, #{args[:sr]}))
AND #{service[:fields][:u][:field]} >= #{u.min}
AND #{service[:fields][:v][:field]} <= #{v.max}
AND #{service[:fields][:g][:field]} >= #{g.min}
AND #{service[:fields][:r][:field]} <= #{r.max}
AND #{service[:fields][:i][:field]} >= #{i.min}
AND #{service[:fields][:z][:field]} <= #{z.max}

    END_ADQL
    query.to_adql(service).should == adql
  end

end