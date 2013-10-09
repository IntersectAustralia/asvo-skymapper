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

    skymapper = registry.datasets[:skymapper]
    skymapper.should_not be_nil

    catalogues = skymapper[:catalogues]
    catalogues.should_not be_nil

    fs_catalogue = catalogues[:fs]
    fs_catalogue.should_not be_nil

    fs_catalogue[:service].should == 'TAP'
    fs_catalogue[:service_end_point].should == 'http://astroa.anu.edu.au:8080/skymapperpublic-asov-tap/tap'
    fs_catalogue[:table_name].should == 'public.fs_distilled'
    fs_catalogue[:ra_column_name].should == 'mean_ra'
    fs_catalogue[:dec_column_name].should == 'mean_dcl'
  end

end