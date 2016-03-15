require 'open-uri'
require 'nokogiri'

class NokogiriRequests

  def initialize(organization, settings={})
    @organization = organization
    @settings = settings
  end

  def query_events(opts={})
    Rails.cache.fetch("#{@organization}4", expires_in: 24.hours) do

      docs = urls.map do |url|
        doc = Nokogiri::HTML(open(url))
      end

      serialized = serialize(docs)

      serialized.map do |event|
        event[:organization] ||= @organization
        event[:favorite] = @settings[:favorite]
        event
      end
    end
  end

end