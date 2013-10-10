require 'spec_helper'

describe VOTable do

  it { should respond_to(:query_status) }
  it { should respond_to(:provider) }
  it { should respond_to(:query) }
  it { should respond_to(:table_fields) }
  it { should respond_to(:table_data) }

end