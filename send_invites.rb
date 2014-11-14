require "active_support"
require "active_support/all"

require "./create_invite"
require "./send_emails"

require "redis"
$REDIS = Redis.new

if $REDIS.get "ran_recently"
  puts "Nothing to do, last ran at #{$REDIS.get("last_ran")}"
  exit
end

# People are stored as a big ol' string in redis
people_txt = $REDIS.get "people"
people = people_txt.strip.split("\n").map do |line|
  pieces = line.split " "

  [pieces[0...-1].join(" "), pieces.last]
end

def good_pairings(people)
  #TODO: check for no recent duplicates (within the last three weeks)
  true
end

while true do
  people.shuffle!

  break if good_pairings(people)
end

loner = people.pop if people.size % 2 == 1

pairings = people.each_slice(2).map do |a, b|
  [a, b]
end

# Add third wheel if we have a loner
if loner
  pairings.sample.push loner
end

pairings.each_with_index do |pairing, index|
  puts "#{index}: #{pairing.inspect}"
end

$REDIS.set "pairings", pairings.inspect

pairings.each_with_index do |pairing, index|
  email_addresses = pairing.map(&:last)

  print email_addresses.inspect

  # Assuming being sent out on Friday morning
  start_time = 5.days.from_now.at_noon
  invite = create_invite start_time

  send_emails pairing, invite

  puts " DONE!"
end

$REDIS.set "last_ran", Time.now
$REDIS.set "ran_recently", true
$REDIS.expire "ran_recently", (1.week.from_now - Time.now).to_i - 7200
