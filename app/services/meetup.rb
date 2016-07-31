class Meetup < ApiRequests

  def serialize(response)
    data = JSON.parse(response.body)
    data['results'].map do |event|
      { id: event['id'],
        name: event['name'],
        organization: event['group']['name'],
        description: event['description'],
        url: event['event_url'],
        start: epoch_string_to_date(event['time']),
        image: event['group']['group_photo'] ? event['group']['group_photo']['thumb_link'] : nil,
        group_id: event['group']['id']
      }
    end
  end

  def default_opts
    {
      member_id: 32036552,
      fields: 'group_photo',
      status: 'upcoming',
      key: '23454b195b7b10272a5e7461a42e3e',
      sign: true
    }
  end

  def url
    'https://api.meetup.com/2/events'
  end
end