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

    fields.should == {
        object_id: { field: 'global_object_id', name: 'Object id', options: 'show-in-list | click-for-detail', group: 'object' },
        ra: { field: 'mean_ra', name: 'Right ascension', options: 'show-in-list | 6dp', group: 'object' },
        dec: { field: 'mean_dcl', name: 'Declination', options: 'show-in-list | 6dp', group: 'object' },
        u: { field: 'flux_u', name: 'Flux u', options: 'show-in-list | 3dp', group: 'filters' },
        v: { field: 'flux_v', name: 'Flux v', options: 'show-in-list | 3dp', group: 'filters' },
        g: { field: 'flux_g', name: 'Flux g', options: 'show-in-list | 3dp', group: 'filters' },
        r: { field: 'flux_r', name: 'Flux r', options: 'show-in-list | 3dp', group: 'filters' },
        i: { field: 'flux_i', name: 'Flux i', options: 'show-in-list | 3dp', group: 'filters' },
        z: { field: 'flux_z', name: 'Flux z', options: 'show-in-list | 3dp', group: 'filters' },
        sigma_ra: { field: 'sigma_ra', name: 'Sigma right ascension', group: 'object' },
        sigma_dec: { field: 'sigma_dcl', name: 'Sigma declination', group: 'object' },
        field_id: { field: 'field_id', name: 'Field id', group: 'object' },
        n_epochs: { field: 'n_epochs', name: 'N epochs', group: 'object' },
        sigma_u: { field: 'sigma_flux_u', name: 'Sigma flux u', group: 'sigma filters' },
        sigma_v: { field: 'sigma_flux_v', name: 'Sigma flux v', group: 'sigma filters' },
        sigma_g: { field: 'sigma_flux_g', name: 'Sigma flux g', group: 'sigma filters' },
        sigma_r: { field: 'sigma_flux_r', name: 'Sigma flux r', group: 'sigma filters' },
        sigma_i: { field: 'sigma_flux_i', name: 'Sigma flux i', group: 'sigma filters' },
        sigma_z: { field: 'sigma_flux_z', name: 'Sigma flux z', group: 'sigma filters' }
    }
  end

  it 'Registry includes fields for main survey catalogue in skymapper dataset' do
    registry = Registry.new(ASVO_REGISTRY_FILEPATH)
    tap_service = registry.find_service('skymapper', 'ms', 'tap')
    fields = tap_service[:fields]

    fields.should == {
        object_id: { field: 'new_object_id', name: 'Object id', options: 'show-in-list | click-for-detail', group: 'object' },
        ra: { field: 'ra', name: 'Right ascension', options: 'show-in-list | 6dp', group: 'object' },
        dec: { field: 'dcl', name: 'Declination', options: 'show-in-list | 6dp', group: 'object' },
        u: { field: 'mean_u', name: 'u', options: 'show-in-list | 3dp', group: 'filters' },
        v: { field: 'mean_v', name: 'v', options: 'show-in-list | 3dp', group: 'filters' },
        g: { field: 'mean_g', name: 'g', options: 'show-in-list | 3dp', group: 'filters' },
        r: { field: 'mean_r', name: 'r', options: 'show-in-list | 3dp', group: 'filters' },
        i: { field: 'mean_i', name: 'i', options: 'show-in-list | 3dp', group: 'filters' },
        z: { field: 'mean_z', name: 'z', options: 'show-in-list | 3dp', group: 'filters' },
        mean_epoch: { field: 'mean_epoch', name: 'Mean epoch', group: 'object' },
        sigma_u: { field: 'sigma_u', name: 'Sigma u', group: 'sigma filters' },
        sigma_v: { field: 'sigma_v', name: 'Sigma v', group: 'sigma filters' },
        sigma_g: { field: 'sigma_g', name: 'Sigma g', group: 'sigma filters' },
        sigma_r: { field: 'sigma_r', name: 'Sigma r', group: 'sigma filters' },
        sigma_i: { field: 'sigma_i', name: 'Sigma i', group: 'sigma filters' },
        sigma_z: { field: 'sigma_z', name: 'Sigma z', group: 'sigma filters' },
        petro_u: { field: 'petro_u', name: 'Petro u', group: 'petro filters' },
        petro_v: { field: 'petro_v', name: 'Petro v', group: 'petro filters' },
        petro_g: { field: 'petro_g', name: 'Petro g', group: 'petro filters' },
        petro_r: { field: 'petro_r', name: 'Petro r', group: 'petro filters' },
        petro_i: { field: 'petro_i', name: 'Petro i', group: 'petro filters' },
        petro_z: { field: 'petro_z', name: 'Petro z', group: 'petro filters' },
        petro_sigma_u: { field: 'petro_sigma_u', name: 'Petro sigma u', group: 'petro sigma filters' },
        petro_sigma_v: { field: 'petro_sigma_v', name: 'Petro sigma v', group: 'petro sigma filters' },
        petro_sigma_g: { field: 'petro_sigma_g', name: 'Petro sigma g', group: 'petro sigma filters' },
        petro_sigma_r: { field: 'petro_sigma_r', name: 'Petro sigma r', group: 'petro sigma filters' },
        petro_sigma_i: { field: 'petro_sigma_i', name: 'Petro sigma i', group: 'petro sigma filters' },
        petro_sigma_z: { field: 'petro_sigma_z', name: 'Petro sigma z', group: 'petro sigma filters' },
        pi: { field: 'pi', name: 'pi', group: 'group1' },
        sigma_pi: { field: 'sigma_pi', name: 'Sigma pi', group: 'group1' },
        mu_x: { field: 'mu_x', name: 'mu x', group: 'group1' },
        mu_y: { field: 'mu_y', name: 'mu y', group: 'group1' },
        sigma_mu_x: { field: 'sigma_mu_x', name: 'Sigma mu x', group: 'group1' },
        sigma_mu_y: { field: 'sigma_mu_y', name: 'Sigma mu y', group: 'group1' },
        variability: { field: 'variability', name: 'Variability', group: 'group1' },
        transient: { field: 'transient', name: 'Transient', group: 'group1' },
        a: { field: 'a', name: 'a', group: 'group2' },
        b: { field: 'b', name: 'b', group: 'group2' },
        theta: { field: 'theta', name: 'Theta', group: 'group2' },
        sigma_a: { field: 'sigma_a', name: 'Sigma a', group: 'group2' },
        sigma_b: { field: 'sigma_b', name: 'Sigma b', group: 'group2' },
        sigma_theta: { field: 'sigma_theta', name: 'Sigma theta', group: 'group2' },
        radius_frac_20: { field: 'radius_frac_20', name: 'Radius frac 20', group: 'group2' },
        radius_frac_90: { field: 'radius_frac_90', name: 'Radius frac 90', group: 'group2' },
        class_star: { field: 'class_star', name: 'Class star', group: 'star' },
        class_desc: { field: 'class_desc', name: 'Class description', group: 'star' },
        field_id_1: { field: 'field_id_1', name: 'Field id 1', group: 'extras' },
        object_id_1: { field: 'object_id_1', name: 'Object id 1', group: 'extras' },
        field_id_2: { field: 'field_id_2', name: 'Field id 2', group: 'extras' },
        object_id_2: { field: 'object_id_2', name: 'Object id 2', group: 'extras' },
        field_id_3: { field: 'field_id_3', name: 'Field id 3', group: 'extras' },
        object_id_3: { field: 'object_id_3', name: 'Object id 3', group: 'extras' },
        field_id_4: { field: 'field_id_4', name: 'Field id 4', group: 'extras' },
        object_id_4: { field: 'object_id_4', name: 'Object id 4', group: 'extras' }
    }
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

    fields.should == {
        ra: { field: 'POINTRA_DEG', name: 'Right ascension', options: 'show-in-list | click-for-detail', group: 'image' },
        dec: { field: 'POINTDEC_DEG', name: 'Declination', options: 'show-in-list | click-for-detail', group: 'image' },
        filter: { field: 'FILTER', name: 'Filter', options: 'show-in-list', group: 'image' },
        image_type: { field: 'IMAGE_TYPE', name: 'Survey', options: 'show-in-list', group: 'image' },
        observation_date: { field: 'DATE', name: 'Observation Date (MJD)', options: 'show-in-list', group: 'image' },
        image_url: { field: 'ACCESSURL', name: 'Image URL', options: 'show-in-list | image-link', group: 'image' },
        object_id: { field: 'OBJECT_ID', name: 'Image id', group: 'group1' },
        title: { field: 'TITLE', name: 'Obs title', group: 'group1' },
        night_id: { field: 'NIGHT_ID', name: 'Night id', group: 'group1' },
        combined_id: { field: 'COMBINED_ID', name: 'Combined id', group: 'group1' },
        naxes: { field: 'NAXES', name: 'Axes', group: 'group1' },
        naxis: { field: 'NAXIS', name: 'Axis length', group: 'group1' },
        scale: { field: 'SCALE', name: 'Axis scale', group: 'group1' },
        format: { field: 'FORMAT', name: 'Observation format', group: 'group2' },
        field_id: { field: 'FIELD_ID', name: 'Field id', group: 'group2' },
        exp_time: { field: 'EXP_TIME', name: 'Exp time', group: 'group2' },
        air_mass: { field: 'AIRMASS', name: 'Air mass', group: 'group2' },
        rotator_pos: { field: 'ROTATOR_POS', name: 'Rotator pos', group: 'group2' },
        object: { field: 'OBJECT', name: 'Object', group: 'group2' },
        binning: { field: 'BINNING', name: 'Binning', group: 'group2' },
        qa_status: { field: 'QA_STATUS', name: 'QA status', group: 'group2' }
    }
  end

end