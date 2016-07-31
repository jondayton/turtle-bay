class Ticketfly < ApiRequests

  def serialize(response)
    data = JSON.parse(response.body)
    data['events'].map do |event|
      { id: event['id'],
        name: event['name'],
        description: event['supportsName'],
        url: event['urlEventDetailsUrl'],
        start: event['startDate'] ? event['startDate'].to_datetime : DateTime.now(),
        image: event['image'] && event['image']['large'] && event['image']['large']['path'] || nil
      }
    end
  end

  def url
    'http://www.ticketfly.com/api/events/upcoming.json'
  end
end