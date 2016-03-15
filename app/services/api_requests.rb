class ApiRequests

  def initialize(organization, settings={})
    @organization = organization
    @settings = settings
  end

  def query_events(opts={})
    Rails.cache.fetch("#{@organization}", expires_in: 24.hours) do
      query_opts = { query: default_opts.merge(opts) }

      response = HTTParty.get(url, query_opts)
      serialized = serialize(JSON.parse(response.body))

      serialized.map do |event|
        event[:organization] ||= @organization
        event[:favorite] = @settings[:favorite]
        event
      end
    end

  end

  def default_opts
    {}
  end

  def url
    ''
  end

  def epoch_string_to_date(string)
    date = string.to_i/1000
    DateTime.strptime(date.to_s, '%s')
  end
end