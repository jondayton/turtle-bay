class EventsController < ApplicationController
  def index
    @events = cooper_hewitt_events + nearby_events + irish_rep_events + gramercy_theatre_events
    @events.sort! { |a, b| a[:start] <=> b[:start] }
  end

  private

  def gramercy_theatre_events
    gramercy_theatre = LiveNation.new('Gramercy Theater')
    gramercy_theatre.query_events({ venueIds: 107 })
  end

  def irish_rep_events
    irish_rep = Ovationtix.new('Irish Repertory', {client_id: 32325, favorite: true})
    irish_rep.query_events
  end

  def cooper_hewitt_events
    cooper_hewitt = Eventbrite.new('Cooper Hewitt', {favorite: true})
    cooper_hewitt.query_events('organizer.id' => 1769743087)
  end

  def nearby_events
    time = DateTime.now + 2.weeks
    st = time.strftime("%Y-%m-%dT%H:%M:%SZ")
    nearby = Eventbrite.new('NearbyEvents')
    nearby.query_events({
      'location.within' => '1km',
      'location.latitude' => '40.753192',
      'location.longitude' => '-73.971733',
      'start_date.range_end' => st,
      'sort_by' => 'date'
    })
  end

end