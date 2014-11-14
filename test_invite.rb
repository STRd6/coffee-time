#TODO: ["", ""]

require "./create_invite"
require "./send_emails"

people = [["Daniel X", "danielx@fogcreek.com"]]

# Assuming being sent out on Friday morning
start_time = 5.days.from_now.at_noon
invite = create_invite start_time

puts invite

send_emails people, invite
