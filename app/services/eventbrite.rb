class Eventbrite < ApiRequests

  def serialize(data)
    data['events'].map do |event|
      { id: event['id'],
        name: event['name']['text'],
        description: event['description']['text'],
        url: event['url'],
        start: event['start']['local'].to_datetime,
        image: event['logo'] ? event['logo']['url'] : nil,
        venue_id: event['venue_id']
      }
    end
  end

  def default_opts
    {
      token: ENV['EVENTBRITE_PERSONAL_TOKEN']
    }
  end

  def url
    'https://www.eventbriteapi.com/v3/events/search/'
  end
end