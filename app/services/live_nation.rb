class LiveNation < ApiRequests

  def serialize(response)
    data = JSON.parse(response)['mavenResult']['result']
    data.reject! { |event| event['title'] == 'The Gramercy Theatre - Fast Lane Pass' }
    data.map do |event|
      id = event['eventID']
      {
        id: id,
        name: event['title'],
        start: DateTime.strptime(event['eventDate'], '%Y-%m-%dT%H'),
        url: "http://www.mercuryeastpresents.com/thegramercytheatre/EventDetail?tmeventid=#{id}",
        image: event['eventImageLocation']
      }
    end
  end

  def url
    "http://www.mercuryeastpresents.com/thegramercytheatre/api/EventCalendar/GetEvents"
  end
end
