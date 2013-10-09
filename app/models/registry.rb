class Registry

  def initialize(registry_file)
    registry_file = File.open(registry_file, 'r') unless registry_file.instance_of?(File)
    registry_yaml = YAML.load(registry_file)
    parse_registry(registry_yaml)
  end

  def datasets
    @datasets
  end

  private

  def parse_registry(yaml)
    @datasets = parse_datasets(yaml) if yaml['datasets']
  end

  def parse_datasets(yaml)
    datasets = {}
    yaml['datasets'].each do |dataset|
      datasets[dataset['dataset']] = parse_dataset(dataset)
    end
    datasets.symbolize_keys
  end

  def parse_dataset(yaml)
    dataset = {}
    dataset[:description] = yaml['description']
    dataset[:catalogues] = parse_catalogues(yaml) if yaml['catalogues']
    dataset.symbolize_keys
  end

  def parse_catalogues(yaml)
    catalogues = {}
    yaml['catalogues'].each do |catalogue|
      catalogues[catalogue['catalogue']] = parse_catalogue(catalogue)
    end
    catalogues.symbolize_keys
  end

  def parse_catalogue(yaml)
    catalogue = yaml
    catalogue.symbolize_keys
  end

end