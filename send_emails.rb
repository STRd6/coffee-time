require "base64"
require "mandrill"

# recipients is an array of name email pairs
# [
#   ["Daniel", "danielx@fogcreek.com"]
#   ...
# ]
#
# invite is an ical text string
# https://tools.ietf.org/html/rfc5545
def send_emails(recipients, invite)
  recipients.each do |person|
    others = (recipients - [person])
    others_names = others.map(&:first).join " and "

    email = person.last

    message = {
     "text"=> "Get to know your coworkers. Randomized lunch meetings with people at Fog Creek. Meet up in person or over a hangout, eat lunch, and chat.

This week you're having lunch with #{others_names}. Be sure to reschedule if you have a confilct.

Enjoy!

- Lunchbox",
     "subject"=> "Lunchbox",
     "from_email"=> "lunchbox@fogcreek.com",
     "from_name"=> "Lunchbox",
     "to" => [{
        "email" => person.last,
        "name" => person.first,
        "type" => "to"
      }],
      "attachments" => [{
        "type" => "text/calendar",
        "name" => "invitation.ics",
        "content" => Base64.encode64(invite)
      }],
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
