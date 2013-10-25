require 'spec_helper'

describe Registry do

  it 'Application config contains registry' do
    Rails.application.config.asvo_registry.should_not be_nil
  end

  it 'Load registry from YAML configuration file' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)
    registry.should_not be_nil
  end

  it 'Registry includes skymapper dataset' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)

    skymapper = registry.find_dataset('skymapper')
    skymapper.should_not be_nil
  end

  it 'Registry includes five second survey catalogue in skymapper dataset' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)

    fs_catalogue = registry.find_catalogue('skymapper', 'fs')
    fs_catalogue.should_not be_nil

    fs_catalogue[:service].should == 'TAP'
    fs_catalogue[:service_end_point].should == 'http://astroa.anu.edu.au:8080/skymapperpublic-asov-tap/tap'
    fs_catalogue[:table_name].should == 'public.fs_distilled'
   end

  it 'Registry includes main survey catalogue survey in skymapper dataset' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)

    ms_catalogue = registry.find_catalogue('skymapper', 'ms')
    ms_catalogue.should_not be_nil

    ms_catalogue[:service].should == 'TAP'
    ms_catalogue[:service_end_point].should == 'http://astroa.anu.edu.au:8080/skymapperpublic-asov-tap/tap'
    ms_catalogue[:table_name].should == 'public.ms_distilled'
  end
  
  it 'Registry includes fields for five second survey catalogue in skymapper dataset' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)
    fs_catalogue = registry.find_catalogue('skymapper', 'fs')
    fields = fs_catalogue[:fields]

    fields[:ra_field].should == 'mean_ra'
    fields[:dec_field].should == 'mean_dcl'
    fields[:object_id_field].should == 'global_object_id'
    fields[:u_field].should == 'flux_u'
    fields[:v_field].should == 'flux_v'
    fields[:g_field].should == 'flux_g'
    fields[:r_field].should == 'flux_r'
    fields[:i_field].should == 'flux_i'
    fields[:z_field].should == 'flux_z'
  end

  it 'Registry includes fields for main survey catalogue in skymapper dataset' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)
    ms_catalogue = registry.find_catalogue('skymapper', 'ms')
    fields = ms_catalogue[:fields]

    fields[:ra_field].should == 'ra'
    fields[:dec_field].should == 'dcl'
    fields[:object_id_field].should == 'new_object_id'
    fields[:u_field].should == 'mean_u'
    fields[:v_field].should == 'mean_v'
    fields[:g_field].should == 'mean_g'
    fields[:r_field].should == 'mean_r'
    fields[:i_field].should == 'mean_i'
    fields[:z_field].should == 'mean_z'
  end

end