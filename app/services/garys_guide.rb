class GarysGuide < NokogiriRequests
  def serialize(docs)
    sections = docs[0][:doc].css('.boxx_none .fbox>div>table>tr')

    events = sections.map do |event|
      text = event.children[0] && event.children[0].children[0] && event.children[0].children[0].content
      next if !text

      @day = text if !!text.match(/,/)
      hour = text if !!text.match(/:/)
      next if !hour

      start = DateTime.strptime(@day + hour, '%A, %b %d%l:%M%P')

      data = event.children[6]
      next if !data

      title = data.at_css('.ftitle a')
      description = data.at_css('.fgray')

      # location = data.at_css('.fdescription')
      # price = event.children[2].children[0].content

      url = title && title.attributes['href'].value || ''

      { name: string_content(title),
        description: string_content(description),
        url: url,
        start: start
      }
    end
    events.compact
  end

  def urls
    ['http://garysguide.com/events']
  end

  private

  def string_content(node)
    node && node.content || ''
  end
end