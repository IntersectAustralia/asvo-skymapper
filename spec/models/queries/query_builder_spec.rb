require 'spec_helper'

describe QueryBuilder do

  it 'Construct query with no args' do
    adql = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM <tablename>
    WHERE
        1=CONTAINS(POINT('ICRS', <ra_column_name>, <dcl_column_name>),
                   CIRCLE('ICRS', <ra_point>, <dcl_point>, <cone_radius> ))
    END_ADQL

    result = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM <tablename>
    WHERE
        1=CONTAINS(POINT('ICRS', <ra_column_name>, <dcl_column_name>),
                   CIRCLE('ICRS', <ra_point>, <dcl_point>, <cone_radius> ))
    END_ADQL
    query = QueryBuilder.new(adql)
    query.build.should == result
  end

  it 'Construct query with args' do
    adql = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM <tablename>
    WHERE
        1=CONTAINS(POINT('ICRS', <ra_column_name>, <dcl_column_name>),
                   CIRCLE('ICRS', <ra_point>, <dcl_point>, <cone_radius> ))
    END_ADQL

    result = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM public.fs_distilled
    WHERE
        1=CONTAINS(POINT('ICRS', mean_ra, mean_dcl),
                   CIRCLE('ICRS', 90.0, -1.0, 1.0 ))
    END_ADQL
    args = {
        tablename: 'public.fs_distilled',
        ra_column_name: 'mean_ra',
        dcl_column_name: 'mean_dcl',
        ra_point: 90.0,
        dcl_point: -1.0,
        cone_radius: 1.0
    }
    query = QueryBuilder.new(adql, args)
    query.build.should == result
  end

end