require 'spec_helper'

describe QueryGenerator do

  it 'Generates point query' do
    args = {
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }
    point_query = QueryGenerator.generate_point_query(args)
    point_query.valid?.should be_true
  end

  it 'Generates point query for all filters' do
    args = {
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

  it 'Generates point query for some filters' do
    args = {
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

  it 'Generates rectangular query' do
    args = {
        ra_min: '178.83871',
        ra_max: '300',
        dec_min: '-1.18844',
        dec_max: '1.8844'
    }
    rectangular_query = QueryGenerator.generate_rectangular_query(args)
    rectangular_query.valid?.should be_true
  end

  it 'Generates rectangular query for all filters' do
    args = {
        ra_min: '178.83871',
        ra_max: '300',
        dec_min: '-1.18844',
        dec_max: '1.8844',
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
    rectangular_query = QueryGenerator.generate_rectangular_query(args)
    rectangular_query.filters.size.should == 6
    rectangular_query.valid?.should be_true
  end

  it 'Generates rectangular query for some filters' do
    args = {
        ra_min: '178.83871',
        ra_max: '300',
        dec_min: '-1.18844',
        dec_max: '1.8844',
        u_min: '1.1',
        u_max: '2.2',
        i_max: '2.2',
        z_min: '1.1',
        z_max: '2.2',
    }
    rectangular_query = QueryGenerator.generate_rectangular_query(args)
    rectangular_query.filters.size.should == 3
    rectangular_query.valid?.should be_true
  end

  it 'Generates image query' do
    args = {
        ra: '178.83871',
        dec: '-1.18844'
    }
    image_query = QueryGenerator.generate_image_query(args)
    image_query.valid?.should be_true
  end

  it 'Generates bulk catalogue query' do
    args = {
        file: Rails.root.join('spec/fixtures/skymapper_bulk_valid_1.csv'),
        sr: '0.05'
    }
    bulk_query = QueryGenerator.generate_bulk_catalogue_query(args)
    bulk_query.valid?.should be_true
  end

  it 'Generates bulk image query' do
    args = {
        file: Rails.root.join('spec/fixtures/skymapper_bulk_valid_1.csv')
    }
    bulk_query = QueryGenerator.generate_bulk_image_query(args)
    bulk_query.valid?.should be_true
  end

end