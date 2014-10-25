require "active_support"
require "./create_invite"
require "./send_emails"

require "redis"
$REDIS = Redis.new

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

  invite = create_invite email_addresses

  send_emails pairing, invite

  puts " DONE!"
end
