class ApiRequests

  def initialize(organization, settings={})
    @organization = organization
    @settings = settings
  end

  def query_events(opts={})
    query_opts = { query: opts.merge(default_opts) }

    response = HTTParty.get(url, query_opts)
    serialized = serialize(JSON.parse(response.body))
    serialized.map do |event|

      event[:organization] = @organization
      event[:favorite] = @settings[:favorite]
      event
    end
  end

  def default_opts
    {}
  end

  def url
    ''
  end
end