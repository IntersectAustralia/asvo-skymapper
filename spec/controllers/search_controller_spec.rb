require 'spec_helper'

describe SearchController do

  it 'search fields are in order' do
    ctrl = SearchController.new
    fields = ctrl.search_fields('fs')
    fields.should == [
        { name: 'Object Id', field: 'global_object_id', type: :show_detail, class: 'detail-link' },
        { name: 'Right ascension', field: 'mean_ra' },
        { name: 'Declination', field: 'mean_dcl' },
        { name: 'U', field: 'flux_u' },
        { name: 'V', field: 'flux_v' },
        { name: 'G', field: 'flux_g' },
        { name: 'R', field: 'flux_r' },
        { name: 'I', field: 'flux_i' },
        { name: 'Z', field: 'flux_z' }
    ]

    fields = ctrl.search_fields('ms')
    fields.should == [
        { name: 'Object Id', field: 'new_object_id', type: :show_detail, class: 'detail-link' },
        { name: 'Right ascension', field: 'ra' },
        { name: 'Declination', field: 'dcl' },
        { name: 'U', field: 'mean_u' },
        { name: 'V', field: 'mean_v' },
        { name: 'G', field: 'mean_g' },
        { name: 'R', field: 'mean_r' },
        { name: 'I', field: 'mean_i' },
        { name: 'Z', field: 'mean_z' }
    ]
  end

  it 'search fields are in order' do
    ctrl = SearchController.new
    fields = ctrl.image_search_fields('image')
    fields.should == [
        { name: 'Right ascension', field: 'POINTRA_DEG' },
        { name: 'Declination', field: 'POINTDEC_DEG' },
        { name: 'Filter', field: 'FILTER' },
        { name: 'Survey', field: 'IMAGE_TYPE' },
        { name: 'Observation Date (MJD)', field: 'DATE' },
        { name: 'Image URL', field: 'ACCESSURL', type: :download_image, class: 'image-link' }
    ]
  end

end