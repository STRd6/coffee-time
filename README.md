Lunchbox
========

Set up weekly lunch gettogethers between random peeps in your org.

Setup
-----

Initialize Redis with a list of names and emails from your organization.

Scheduling
----------

Add a Heroku scheduled task that runs daily:

    bundle exec ruby send_invites.rb
