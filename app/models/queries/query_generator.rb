class QueryGenerator

  def self.generate_point_query(dataset, args)
    registry = Rails.application.config.asvo_registry
    registry_dataset = registry.datasets[dataset]
    catalogue = registry_dataset[:catalogues][args[:catalogue]]
    args = {
      table_name: catalogue[:table_name],
      ra_column_name: catalogue[:ra_column_name],
      dec_column_name: catalogue[:dec_column_name],
      ra: args[:ra],
      dec: args[:dec],
      sr: args[:sr]
    }
    query = PointQuery.create(args)
    query
  end

end