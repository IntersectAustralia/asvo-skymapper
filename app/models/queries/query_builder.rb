class QueryBuilder

  def initialize(query, args = nil)
    @query = query
    @args = args
  end

  def build
    return @query unless @args

    query = @query
    @args.each do |key, value|
      query = query.gsub("<#{key}>", value.to_s)
    end

    query
  end

end