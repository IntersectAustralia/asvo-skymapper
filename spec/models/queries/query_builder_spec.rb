require 'spec_helper'

describe QueryBuilder do

  it 'Construct query with no args' do
    adql = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM <table_name>
    WHERE
        1=CONTAINS(POINT('ICRS', <ra_column_name>, <dec_column_name>),
                   CIRCLE('ICRS', <ra>, <dec>, <sr> ))
    END_ADQL

    result = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM <table_name>
    WHERE
        1=CONTAINS(POINT('ICRS', <ra_column_name>, <dec_column_name>),
                   CIRCLE('ICRS', <ra>, <dec>, <sr> ))
    END_ADQL
    query = QueryBuilder.new(adql)
    query.build.should == result
  end

  it 'Construct query with args' do
    adql = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM <table_name>
    WHERE
        1=CONTAINS(POINT('ICRS', <ra_column_name>, <dec_column_name>),
                   CIRCLE('ICRS', <ra>, <dec>, <sr> ))
    END_ADQL

    result = <<-END_ADQL
SELECT
    TOP 1000
    *
    FROM public.fs_distilled
    WHERE
        1=CONTAINS(POINT('ICRS', mean_ra, mean_dcl),
                   CIRCLE('ICRS', 62.70968, -1.18844, 0.5 ))
    END_ADQL
    args = {
        table_name: 'public.fs_distilled',
        ra_column_name: 'mean_ra',
        dec_column_name: 'mean_dcl',
        ra: 62.70968,
        dec: -1.18844,
        sr: 0.5
    }
    query = QueryBuilder.new(adql, args)
    query.build.should == result
  end

end