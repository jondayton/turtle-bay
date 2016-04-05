require 'open-uri'
require 'nokogiri'

class NokogiriRequests

  def initialize(organization, settings={})
    @organization = organization
    @settings = settings
  end

  def query_events(opts={})
    Rails.cache.fetch("#{@organization}", expires_in: 24.hours) do

      docs = pages_html(urls)
      serialized = serialize(docs)

      serialized.map do |event|
        event[:organization] ||= @organization
        event[:favorite] = @settings[:favorite]
        event
      end
    end
  end

  def pages_html(urls)
    urls.map do |url|
      doc = Nokogiri::HTML(open(encoded_url(url)))
      { doc: doc, url: url }
    end
  end

  def encoded_url(url)
    URI.encode(URI.decode(url))
  end

  def serialize(html_objects)
    html_objects.map do |obj|
      serialize_each(obj[:doc], obj[:url])
    end
  end
end