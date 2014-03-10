require 'spec_helper'

describe SearchController do

  def strip_fields(fields)
    fields.select { |field| field[:options] and field[:options].include?('show-in-list') }.map { |field| { name: field[:name], field: field[:field] } }
  end

  it 'search fields are in order' do
    ctrl = SearchController.new
    fields = ctrl.search_fields('fs', 'tap')
    strip_fields(fields).should == [
        { name: 'Object id', field: 'global_object_id' },
        { name: 'Right ascension', field: 'mean_ra' },
        { name: 'Declination', field: 'mean_dcl' },
        { name: 'Flux u', field: 'flux_u' },
        { name: 'Flux v', field: 'flux_v' },
        { name: 'Flux g', field: 'flux_g' },
        { name: 'Flux r', field: 'flux_r' },
        { name: 'Flux i', field: 'flux_i' },
        { name: 'Flux z', field: 'flux_z' }
    ]

    fields = ctrl.search_fields('ms', 'tap')
    strip_fields(fields).should == [
        { name: 'Object id', field: 'new_object_id' },
        { name: 'Right ascension', field: 'ra' },
        { name: 'Declination', field: 'dcl' },
        { name: 'u', field: 'mean_u' },
        { name: 'v', field: 'mean_v' },
        { name: 'g', field: 'mean_g' },
        { name: 'r', field: 'mean_r' },
        { name: 'i', field: 'mean_i' },
        { name: 'z', field: 'mean_z' }
    ]

    fields = ctrl.search_fields('image', 'siap')
    strip_fields(fields).should == [
        { name: 'Right ascension', field: 'POINTRA_DEG' },
        { name: 'Declination', field: 'POINTDEC_DEG' },
        { name: 'Filter', field: 'FILTER' },
        { name: 'Survey', field: 'IMAGE_TYPE' },
        { name: 'Observation Date (MJD)', field: 'DATE' },
        { name: 'FITS Image URL', field: 'ACCESSURL' }
    ]
  end

  # SKYM-82: Leading zeros are stripped
  it 'strips leading zeros from search parameters' do
    ctrl = SearchController.new
    params = [{value: '000123.123'}]
    ctrl.clean_parameters(params).should == [{value: '123.123'}]
    params = [{value: '-000.123'}]
    ctrl.clean_parameters(params).should == [{value: '-0.123'}]
  end

end