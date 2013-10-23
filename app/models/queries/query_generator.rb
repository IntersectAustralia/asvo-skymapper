class QueryGenerator

  def self.generate_point_query(args)
    registry = Rails.application.config.asvo_registry
    catalogue = registry.find_catalogue(args[:dataset], args[:catalogue])
    query_args = {
      table_name: catalogue[:table_name],
      ra_field: catalogue[:fields][:ra_field],
      dec_field: catalogue[:fields][:dec_field],
      ra: args[:ra],
      dec: args[:dec],
      sr: args[:sr]
    }
    query = PointQuery.new(query_args)
    query.filters = generate_query_filters(catalogue[:fields], args)
    query
  end

  def self.generate_rectangular_query(args)
    registry = Rails.application.config.asvo_registry
    catalogue = registry.find_catalogue(args[:dataset], args[:catalogue])
    query_args = {
      table_name: catalogue[:table_name],
      ra_field: catalogue[:fields][:ra_field],
      dec_field: catalogue[:fields][:dec_field],
      ra_min: args[:ra_min],
      ra_max: args[:ra_max],
      dec_min: args[:dec_min],
      dec_max: args[:dec_max]
    }
    query = RectangularQuery.new(query_args)
    query
  end

  protected

  def self.generate_query_filters(fields, args)
    filters = []
    [:u, :v, :g, :r, :i, :z].each do |filter|
      field = fields["#{filter.to_s}_field".to_sym]
      min = args["#{filter.to_s}_min".to_sym]
      max = args["#{filter.to_s}_max".to_sym]
      f = MagnitudeFilter.new(field: field, min: min, max: max)
      filters.push(f) if f.valid?
    end
    filters
  end

end