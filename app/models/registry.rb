class Registry

  def initialize(registry_file)
    registry_file = File.open(registry_file, 'r') unless registry_file.instance_of?(File)
    registry_yaml = YAML.load(registry_file)
    @datasets = {}
    registry_yaml.each do |dataset|
      @datasets[dataset['dataset'].to_sym] = dataset
    end
  end

  def datasets
    @datasets
  end

end