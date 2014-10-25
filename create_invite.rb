require "active_support"
require "icalendar"

def create_invite(emails)
  timezone_id = 'America/New_York'
  timezone = TZInfo::Timezone.get(timezone_id)

  # Assuming being sent out on Friday morning
  start_time = 5.days.from_now.at_noon
  end_time = start_time + 1.hour

  attendee_list = emails.map do |email|
    "mailto:#{email}"
  end.join " "

  calendar = Icalendar::Calendar.new
  calendar.event do |event|
    event.dtstart = Icalendar::Values::DateTime.new start_time, 'tzid' => timezone_id
    event.dtend   = Icalendar::Values::DateTime.new end_time, 'tzid' => timezone_id
    event.attendee    = attendee_list
    event.summary = "Lunchbox"
    event.description = "Randomized lunch meetings with people at Fog Creek"
    event.organizer = "mailto:lunchbox@fogcreek.com"
  end

  calendar.to_ical
end
