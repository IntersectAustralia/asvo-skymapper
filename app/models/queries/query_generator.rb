class QueryGenerator

  def self.generate_point_query(args)
    registry = Rails.application.config.asvo_registry
    catalogue = registry.find_catalogue(args[:dataset], args[:catalogue])
    args = {
      table_name: catalogue[:table_name],
      ra_field: catalogue[:fields][:ra_field],
      dec_field: catalogue[:fields][:dec_field],
      ra: args[:ra],
      dec: args[:dec],
      sr: args[:sr]
    }
    query = PointQuery.create(args)
    query
  end

  def self.generate_rectangular_query(args)
    registry = Rails.application.config.asvo_registry
    catalogue = registry.find_catalogue(args[:dataset], args[:catalogue])
    args = {
      table_name: catalogue[:table_name],
      ra_field: catalogue[:fields][:ra_field],
      dec_field: catalogue[:fields][:dec_field],
      ra_min: args[:ra_min],
      ra_max: args[:ra_max],
      dec_min: args[:dec_min],
      dec_max: args[:dec_max]
    }
    query = RectangularQuery.create(args)
    query
  end

end