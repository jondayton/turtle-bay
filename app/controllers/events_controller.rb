class EventsController < ApplicationController
  def index
    @events = [
      cooper_hewitt_events,
      nearby_events,
      irish_rep_events,
      gramercy_theatre_events,
      drom_events,
      meetup_events,
      instituto_events,
      garys_guide_events,
      iq2_events
    ]

    @events.flatten!

    #It's a favorite or a weekend event or a late event
    @events.select! do |event|
      current = event[:start] > Time.now - 6.hours
      favorite = event[:favorite]
      weekend = event[:start].wday % 6 === 0
      late = event[:start].hour >= 19
      current && (favorite || weekend || late)
    end
    @events.sort! { |a, b| a[:start] <=> b[:start] }

    respond_to do |format|
      format.json { render json: @events }
      format.html
    end
  end

  private

  def iq2_events
    iq2 = IQ2.new('Intelligence Squared', { favorite: true })
    iq2.query_events()
  end

  def meetup_events
    meetup = Meetup.new('Meetup')
    meetup.query_events({ member_id: 32036552 })
  end

  def instituto_events
    instituto = Instituto.new('Instituto Cervantes', { favorite: true })
    instituto.query_events()
  end

  def drom_events
    drom = Ticketfly.new('DROM')
    drom.query_events({ venueId: 1767 })
  end

  def gramercy_theatre_events
    now = DateTime.now
    three_months = now + 8.weeks
    gramercy_theatre = LiveNation.new('Gramercy Theater')
    gramercy_theatre.query_events({
      startDate: now.strftime("%m/%d/%Y"),
      endDate: three_months.strftime("%m/%d/%Y"),
      venueIds: 107,
      limit: 200,
      offset: 1,
      genre: nil,
      artist: nil,
      offerType: nil
    })
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
    nearby = Eventbrite.new('Nearby Events')
    nearby.query_events({
      'location.within' => '1km',
      'location.latitude' => '40.753192',
      'location.longitude' => '-73.971733',
      'start_date.range_end' => st,
      'sort_by' => 'date'
    })
  end

  def garys_guide_events
    garys_guide = GarysGuide.new("Gary's Guide")
    garys_guide.query_events.select { |e| e[:start].hour >= 19 }
  end

end
