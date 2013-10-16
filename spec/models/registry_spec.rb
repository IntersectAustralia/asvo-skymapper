require 'spec_helper'

describe Registry do

  it 'Application config contains registry' do
    Rails.application.config.asvo_registry.should_not be_nil
  end

  it 'Load registry from YAML configuration file' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)
    registry.should_not be_nil
  end

  it 'Load skymapper registry from YAML configuration file' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)

    skymapper = registry.find_dataset(:skymapper)
    skymapper.should_not be_nil

    fs_catalogue = registry.find_catalogue(:skymapper, :fs)
    fs_catalogue.should_not be_nil

    fs_catalogue[:service].should == 'TAP'
    fs_catalogue[:service_end_point].should == 'http://astroa.anu.edu.au:8080/skymapperpublic-asov-tap/tap'
    fs_catalogue[:table_name].should == 'public.fs_distilled'
    fs_catalogue[:ra_column_name].should == 'mean_ra'
    fs_catalogue[:dec_column_name].should == 'mean_dcl'

    ms_catalogue = registry.find_catalogue(:skymapper, :ms)
    ms_catalogue.should_not be_nil

    ms_catalogue[:service].should == 'TAP'
    ms_catalogue[:service_end_point].should == 'http://astroa.anu.edu.au:8080/skymapperpublic-asov-tap/tap'
    ms_catalogue[:table_name].should == 'public.ms_distilled'
    ms_catalogue[:ra_column_name].should == 'ra'
    ms_catalogue[:dec_column_name].should == 'dcl'
  end

end