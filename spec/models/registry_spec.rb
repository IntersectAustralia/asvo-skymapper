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

    tap_service = registry.find_service('skymapper', 'fs', 'tap')
    tap_service[:service].should == 'TAP'
    tap_service[:service_end_point].should == 'http://astroa.anu.edu.au:8080/skymapperpublic-asov-tap/tap'
    tap_service[:table_name].should == 'public.fs_distilled'
   end

  it 'Registry includes main survey catalogue survey in skymapper dataset' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)

    ms_catalogue = registry.find_catalogue('skymapper', 'ms')
    ms_catalogue.should_not be_nil

    tap_service = registry.find_service('skymapper', 'ms', 'tap')
    tap_service[:service].should == 'TAP'
    tap_service[:service_end_point].should == 'http://astroa.anu.edu.au:8080/skymapperpublic-asov-tap/tap'
    tap_service[:table_name].should == 'public.ms_distilled'
  end
  
  it 'Registry includes fields for five second survey catalogue in skymapper dataset' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)
    tap_service = registry.find_service('skymapper', 'fs', 'tap')
    fields = tap_service[:fields]

    fields[:ra_field][:field].should == 'mean_ra'
    fields[:ra_field][:name].should == 'Right ascension'

    fields[:dec_field][:field].should == 'mean_dcl'
    fields[:dec_field][:name].should == 'Declination'

    fields[:object_id_field][:field].should == 'global_object_id'
    fields[:object_id_field][:name].should == 'Object Id'

    fields[:u_field][:field].should == 'flux_u'
    fields[:u_field][:name].should == 'U'

    fields[:v_field][:field].should == 'flux_v'
    fields[:v_field][:name].should == 'V'

    fields[:g_field][:field].should == 'flux_g'
    fields[:g_field][:name].should == 'G'

    fields[:r_field][:field].should == 'flux_r'
    fields[:r_field][:name].should == 'R'

    fields[:i_field][:field].should == 'flux_i'
    fields[:i_field][:name].should == 'I'

    fields[:z_field][:field].should == 'flux_z'
    fields[:z_field][:name].should == 'Z'
  end

  it 'Registry includes fields for main survey catalogue in skymapper dataset' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)
    tap_service = registry.find_service('skymapper', 'ms', 'tap')
    fields = tap_service[:fields]

    fields[:ra_field][:field].should == 'ra'
    fields[:ra_field][:name].should == 'Right ascension'

    fields[:dec_field][:field].should == 'dcl'
    fields[:dec_field][:name].should == 'Declination'

    fields[:object_id_field][:field].should == 'new_object_id'
    fields[:object_id_field][:name].should == 'Object Id'

    fields[:u_field][:field].should == 'mean_u'
    fields[:u_field][:name].should == 'U'

    fields[:v_field][:field].should == 'mean_v'
    fields[:v_field][:name].should == 'V'

    fields[:g_field][:field].should == 'mean_g'
    fields[:g_field][:name].should == 'G'

    fields[:r_field][:field].should == 'mean_r'
    fields[:r_field][:name].should == 'R'

    fields[:i_field][:field].should == 'mean_i'
    fields[:i_field][:name].should == 'I'

    fields[:z_field][:field].should == 'mean_z'
    fields[:z_field][:name].should == 'Z'
  end

  it 'Registry includes image catalogue survey in skymapper dataset' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)

    image_catalogue = registry.find_catalogue('skymapper', 'image')
    image_catalogue.should_not be_nil

    siap_service = registry.find_service('skymapper', 'image', 'siap')
    siap_service[:service].should == 'SIAP'
    siap_service[:service_end_point].should == 'http://astroa.anu.edu.au/skymapper/image_siap/siap'
  end

  it 'Registry includes fields for image catalogue in skymapper dataset' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)
    siap_service = registry.find_service('skymapper', 'image', 'siap')
    fields = siap_service[:fields]

    fields[:ra_field][:field].should == 'POINTRA_DEG'
    fields[:ra_field][:name].should == 'Right ascension'

    fields[:dec_field][:field].should == 'POINTDEC_DEG'
    fields[:dec_field][:name].should == 'Declination'

    fields[:filter_field][:field].should == 'FILTER'
    fields[:filter_field][:name].should == 'Filter'

    fields[:survey_field][:field].should == 'IMAGE_TYPE'
    fields[:survey_field][:name].should == 'Survey'

    fields[:observation_date_field][:field].should == 'DATE'
    fields[:observation_date_field][:name].should == 'Observation Date (MJD)'

    fields[:image_url][:field].should == 'ACCESSURL'
    fields[:image_url][:name].should == 'Image URL'
  end

end