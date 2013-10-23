require 'spec_helper'

describe QueryGenerator do

  it 'Generates point query for dataset skymapper and catalogue fs' do
    args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }
    point_query = QueryGenerator.generate_point_query(args)
    point_query.valid?.should be_true
  end

  it 'Generates point query for dataset skymapper and catalogue ms' do
    args = {
        dataset: 'skymapper',
        catalogue: 'ms',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }
    point_query = QueryGenerator.generate_point_query(args)
    point_query.valid?.should be_true
  end

  it 'Generates point query for dataset skymapper and catalogue fs all filters' do
    args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5',
        u_min: '1.1',
        u_max: '2.2',
        v_min: '1.1',
        v_max: '2.2',
        g_min: '1.1',
        g_max: '2.2',
        r_min: '1.1',
        r_max: '2.2',
        i_min: '1.1',
        i_max: '2.2',
        z_min: '1.1',
        z_max: '2.2',
    }
    point_query = QueryGenerator.generate_point_query(args)
    point_query.filters.size.should == 6
    point_query.valid?.should be_true
  end

  it 'Generates point query for dataset skymapper and catalogue ms all filters' do
    args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5',
        u_min: '1.1',
        u_max: '2.2',
        v_min: '1.1',
        v_max: '2.2',
        g_min: '1.1',
        g_max: '2.2',
        r_min: '1.1',
        r_max: '2.2',
        i_min: '1.1',
        i_max: '2.2',
        z_min: '1.1',
        z_max: '2.2',
    }
    point_query = QueryGenerator.generate_point_query(args)
    point_query.filters.size.should == 6
    point_query.valid?.should be_true
  end

  it 'Generates point query for dataset skymapper and catalogue fs some filters' do
    args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5',
        u_min: '1.1',
        u_max: '2.2',
        i_max: '2.2',
        z_min: '1.1',
        z_max: '2.2',
    }
    point_query = QueryGenerator.generate_point_query(args)
    point_query.filters.size.should == 3
    point_query.valid?.should be_true
  end

  it 'Generates point query for dataset skymapper and catalogue ms some filters' do
    args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5',
        u_min: '1.1',
        u_max: '2.2',
        i_max: '2.2',
        z_min: '1.1',
        z_max: '2.2',
    }
    point_query = QueryGenerator.generate_point_query(args)
    point_query.filters.size.should == 3
    point_query.valid?.should be_true
  end

end