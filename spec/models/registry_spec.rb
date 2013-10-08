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
    registry.datasets[:skymapper].should_not be_nil
  end

end