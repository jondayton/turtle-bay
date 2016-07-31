class LiveNation < ApiRequests

  def serialize(response)
    data = JSON.parse(response)['result']
    data.map do |event|
      {
        id: event['eventId'],
        name: event['artists'],
        start: DateTime.strptime(event['eventDate'], '%Y-%m-%dT%H'),
        url: event['BuyTicketUrl'],
        image: event['eventImageLocation']
      }
    end
  end

  def url
    "http://venue.thegramercytheatre.com/api/EventCalendar/GetEvents"
  end
end
