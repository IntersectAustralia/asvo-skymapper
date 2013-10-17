class Registry

  def initialize(registry_file)
    @registry_file = registry_file.instance_of?(File) ? registry_file : File.open(registry_file, 'r')
    @registry_yaml = YAML.load(@registry_file)
  end

  def raw
    @registry_yaml
  end

  def find_dataset(dataset_name)
    @registry_yaml[:datasets].select { |x| x[:dataset] == dataset_name }.first
  end

  def find_catalogue(dataset_name, catalogue_name)
    dataset = find_dataset(dataset_name)
    dataset[:catalogues].select { |x| x[:catalogue] == catalogue_name }.first
  end

end