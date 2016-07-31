class Ovationtix < ApiRequests

  def serialize(response)
    data = JSON.parse(response.body)
    events = []
    data['seriesInformation'].each do |series|
      events << {
        show_id: series['productionId'],
        name: series['productionName'] + " playing",
        url: 'https://web.ovationtix.com/trs/cal/32325',
        start: epoch_string_to_date(series['firstPerformanceDate'])
      }

      events << {
          show_id: series['productionId'],
          name: series['productionName'] + " closes",
          url: 'https://web.ovationtix.com/trs/cal/32325',
          start: epoch_string_to_date(series["lastPerformanceDate"])
      }

    end
    events
  end

  def url
    "https://api.ovationtix.com/public/series/client(#{@settings[:client_id]})"
  end

end