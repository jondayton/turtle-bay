class Instituto < NokogiriRequests

  def serialize_each(doc, url)
    text_date = doc.at_css('.meeting-times td').text
    {
      name: doc.at_css('meta[property="og:title"]').attributes['content'].value,
      start: DateTime.strptime(text_date, '%h %e, %Y').in_time_zone + 12.hours,
      description: doc.at_css('meta#pagedesc').attributes['content'].value,
      url: doc.at_css('meta#pageurl').attributes['content'].value
    }
  end

  def urls
    top_level = 'https://apm.activecommunities.com/institutocervantes/Activity_Search?ActivityCategoryID=23&isSearch=true&applyFiltersDefaultValue=true'
    doc = Nokogiri::HTML(open(top_level))
    doc.css('.an-activityName').map do |link|
      link.attributes['href'].value
    end
  end
end