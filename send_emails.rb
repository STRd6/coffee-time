require "base64"
require "mailgun"

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
    # TODO: Can't get multi-way reply-to working
    # this will cover it for 90% of the time
    reply_to = others.first.last
    email = person.last

    message = {
      :text => "This week you're meeting with #{others_names} on Wednesday 12pm EST.

Get to know your coworkers. Meet up in person or over a hangout, grab a coffee, and chat. Plan to meet for about half an hour and please reschedule if you have a conflict.

Enjoy!

P.S. Email danielx@fogcreek.com with questions, comments or suggestions about CoffeeTime.

- Mr. CoffeeTime",
      :subject => "CoffeeTime with #{others_names}",
      :from => "Daniel X <danielx@fogcreek.com>",
      :to => "#{person.first} <#{person.last}>",
      :"h:Reply-To" => reply_to
    }

    mailgun = Mailgun::Client.new ENV['MAILGUN_API_KEY']
    sending_domain = ENV['MAILGUN_DOMAIN']

    begin
      result = mailgun.send_message sending_domain, message
    rescue => e
      puts ENV['MAILGUN_API_KEY']
      puts sending_domain
      # $REDIS.rpush "retries", {person: person, others_names: others_names}.inspect
      puts "An error occurred sending email: #{e.class} - #{e.message}"
    end
  end
end
