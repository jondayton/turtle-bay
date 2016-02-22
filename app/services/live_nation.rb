class LiveNation < ApiRequests

  def serialize(data)
    data.map do |event|
      {
        id: event['EventId'],
        name: event['Artists'],
        start: DateTime.strptime(event['EventDate'], '%Y-%m-%dT%H'),
        url: event['BuyTicketUrl'],
        image: event['EventImageUrl']
      }
    end
  end

  def url
    "http://venue.thegramercytheatre.com/api/TapEvent/GetEventCalendar"
  end

  def default_opts
    {
      departmentId: 8,
      numberOfEvents: 20,
      eventId: nil,
      offerId: 0
    }
  end
end