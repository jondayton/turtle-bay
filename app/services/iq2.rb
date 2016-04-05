class IQ2 < NokogiriRequests
  def serialize_each(doc, url)
    @doc = doc
    text_date = strip_at_css('#eventhead p:nth-child(2)').gsub("\u00A0", "") #get rid of non-breaking whitespace
    {
      name: strip_at_css('#eventhead h1'),
      start: DateTime.strptime(text_date, '%A, %h %e, %Y | %I:%M%P'),
      description: strip_at_css('#overview p:nth-child(2)'),
      url: url
    }
  end

  def urls
    top_level = 'http://www.kaufmanmusiccenter.org/mch/series/intelligence-squared-u.s.-debates/'
    doc = Nokogiri::HTML(open(top_level))
    doc.css('.entry a').map do |link|
      link.attributes['href'].value
    end
  end

  private

  def strip_at_css(selector)
    elt = @doc.at_css(selector)
    elt && elt.text.strip || ''
  end
end