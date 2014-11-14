require "active_support"
require "icalendar"

def create_invite(start_time)
  timezone_id = 'America/New_York'
  timezone = TZInfo::Timezone.get(timezone_id)

  end_time = start_time + 1.hour

  calendar = Icalendar::Calendar.new
  calendar.event do |event|
    event.dtstart = Icalendar::Values::DateTime.new start_time, 'tzid' => timezone_id
    event.dtend   = Icalendar::Values::DateTime.new end_time, 'tzid' => timezone_id
    event.summary = "Lunchbox"
    event.description = "Randomized lunch meetings with people at Fog Creek"
    event.organizer = "mailto:lunchbox@fogcreek.com"
  end

  calendar.to_ical
end
