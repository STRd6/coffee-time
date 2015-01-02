require "base64"
require "mandrill"

# recipients is an array of name email pairs
# [
#   ["Daniel", "danielx@fogcreek.com"]
#   ...
# ]

def send_emails(recipients)
  recipients.each do |person|
    others = (recipients - [person])
    others_names = others.map do |person|
      "#{person.first} (#{person.last})"
    end.join " and "

    email = person.last

    message = {
     "text"=> "This week you're meeting with #{others_names} on Wednesday 12pm EST.

Get to know your coworkers. Meet up in person or over a hangout, grab a coffee, and chat. Plan to meet for about half an hour and please reschedule if you have a conflict.

Enjoy!

P.S. Email danielx@fogcreek.com with questions, comments or suggestions about CoffeeTime.

- Mr. CoffeeTime",
     "subject"=> "CoffeeTime with #{others_names}",
     "from_email"=> "danielx@fogcreek.com",
     "from_name"=> "CoffeeTime",
     "to" => [{
        "email" => person.last,
        "name" => person.first,
        "type" => "to"
      }]
    }

    mandrill = Mandrill::API.new

    begin
      result = mandrill.messages.send message
    rescue Mandrill::Error => e
      $REDIS.rpush "retries", {person: person, invite: invite, others_names: others_names}.inspect
      puts "A mandrill error occurred: #{e.class} - #{e.message}"
    end
  end
end
