require 'spec_helper'

describe QueryGenerator do

  it 'Generates point query for dataset skymapper and catalogue fs' do
    args = {
        dataset: :skymapper,
        catalogue: :fs,
        ra: 90.0,
        dec: -1.0,
        sr: 1.0
    }
    point_query = QueryGenerator.generate_point_query(args)
    point_query.valid?.should be_true
  end

end