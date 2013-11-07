class QueryGenerator

  def self.generate_point_query(args)
    query_args = {
      ra: args[:ra],
      dec: args[:dec],
      sr: args[:sr]
    }
    query = PointQuery.new(query_args, args[:limit])
    query.filters = generate_query_filters(args)
    query
  end

  def self.generate_rectangular_query(args)
    query_args = {
      ra_min: args[:ra_min],
      ra_max: args[:ra_max],
      dec_min: args[:dec_min],
      dec_max: args[:dec_max]
    }
    query = RectangularQuery.new(query_args, args[:limit])
    query.filters = generate_query_filters(args)
    query
  end

  def self.generate_image_query(args)
    query_args = {
        ra: args[:ra],
        dec: args[:dec]
    }
    query = ImageQuery.new(query_args)
    query
  end

  protected

  def self.generate_query_filters(args)
    filters = []
    %w[u v g r i z].each do |filter|
      min = args["#{filter.to_s}_min".to_sym]
      max = args["#{filter.to_s}_max".to_sym]
      f = MagnitudeFilter.new(name: filter, min: min, max: max)
      filters.push(f) if f.valid?
    end
    filters
  end

end