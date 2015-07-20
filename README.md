CoffeeTime
==========

Set up casual weekly mettings between random people in your organization.

Why
---

Maintaining company culture, enhancing cross team communication, serendipitous learning are all important things. They often happen naturally as coworkers share an office space. What happens when many people are remote? Chance encounters with other people can become far more rare.

CoffeeTime was created to pair people up randomly to talk to one another. It doesn't matter what level in the org chart, or what role a person plays. Anyone can be matched up with anyone for a 30 minute video chat.

The most important things to learn are often the things you didn't even know you needed to know. By making more connections with the people you work with it increases the likelihood that you'll have access to someone who can help. Maybe another person is having a similar problem to one you had and you can point them in the right direction. Maybe you just end up making a new friend!

What
----

This is a simple scheduled mailer that runs for free on Heroku and emails everyone with their match for the week.

The implementation is not the prettiest, there are some hacks, but it was quick to create and let us test out if randomly pairing people up for meetings is even a good idea.

Setup
-----

Create a heroku app and install Mandrill, Redis to Go, and Heroku Scheduler addons.

Create a `.env` file with your tokens.

    MANDRILL_APIKEY=...
    REDIS_URL=...

Initialize Redis with a list of names and emails from your organization.

Create a file named `people.txt` with entries like so:

    Daniel X emailaddress@example.com
    Name email@example.com
    ...

Then run:

    bundle exec foreman run ruby init.rb

This creates a list of people to match up in Redis.

"Testing"
---------

This test actually sends the emails based on your environment configuration.

    bundle exec foreman run ruby test_invite.rb

Scheduling
----------

Add a Heroku scheduled task that runs daily:

    bundle exec ruby send_invites.rb

This will check every day if it's been a week since the last email was sent out, if it has, it sends a new email.

We'd actually prefer to schedule for weekly, but daily is the maximum period allowed with Heroku Scheduler
