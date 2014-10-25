require "redis"

redis = Redis.new

people_txt = File.read("people.txt")

redis.set "people", people_txt

puts "Stored:"
puts people_txt
