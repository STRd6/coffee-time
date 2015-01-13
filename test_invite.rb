require "active_support"
require "active_support/all"

require "./send_emails"

people = [["Daniel X", "danielx@fogcreek.com"], ["Dr. Example", "doctor@example.com"]]

send_emails people
