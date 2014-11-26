# Akismet Plugin for Discourse Forum

## Spam Sucks, Fight it with Akismet

Discourse is great, but spam can be a problem. [Akismet](http://akismet.com/) is a well known service that has an
algorithm for detecting spam.  Akismet is NOT free for commerical use, but can be for personal use.  To use this 
plugin you will need an Akismet API key.  You can get a key by starting out [here](http://akismet.com/plans/).

## How it Works
The plugin works by creating a new table where we collect info about a new post's http request.  After the post is created 
we link that data with the post.  Every 10 minutes a background jobs run which looks for posts that were created in the last 12 minutes.
All new posts are sent to Akismet to determine if they are spam or not.  If a post is deemed spam, it is deleted and placed in
a moderator queue where admins can take action against it. An admin can do the following...

Action          | Result
-------------   | -------------
Confirm         | confirms the post as spam, leaving it deleted
Allow           | Akismet thought something was spam but it wasn't. This undeletes the post and tells Akismet that it wasn't spam. Akismet gets smarter so it hopefully won't make the same mistake twice. 
Delete user     | This is the nuclear option. It will delete the user and all their posts and topics and block their email and ip address.

## What Data is Sent to Akismet

Field Name    | Discourse Value
------------- | -------------
Author        | User's Name
Author Email  | We don't send it - omitted for security
Comment Type  | "forum-post"
Content       | Post's raw column
Permalink     | Link to topic
User IP       | IP address of request
User Agent    | User agent of request
Referrer      | HTTP referer of request

## Setup

Do the following
````
cd plugins
git clone https://github.com/verdi327/akismet.git
cd ..
export AKISMET_KEY='YOUR API KEY'
export SITE_DOMAIN='YOUR SITE'S DOMAIN' # ex - dev: 'http://localhost3000' | prod: 'https://newrelic.discuss.com'
rake akismet:install:migrations
rake db:migrate SCOPE=akismet
````

This plugin also comes with Hipchat support.  If you want to be notified when Akismet has detected spam, set the following ENV variables. It will post the total number of spam posts found and give you a link to the moderator queue.

````
export HIPCHAT_TOKEN='YOUR HIPCHAT TOKEN'
export NOTIFY_HIPCHAT=true;
export HIPCHAT_ROOM_ID='YOUR HIPCHAT ROOM ID';
export HIPCHAT_MSG_COLOR='COLOR YOU WANT'; # red, yellow, purple, green, gray
````

## Testing
Once you have the plugin installed, let's do a quick test to make sure everything is working.  Login as a non admin user and create a new topic and post. Use the following info.
````
title: Spam test - Will this plugin do what it says!
post: love vashikaran, love vashikaran specialist,919828891153 love vashikaran special black magic specialist hurry hurry love now
````
Now, go to `/sidekiq/scheduler` and find the `CheckForSpamPosts` jobs and trigger it.  Now, go to `/admin` and look for the tab that says `Akismet` in the menu bar.  Upon clicking you should see the post with some additional info about it.

## Debugging
Some basic logging has been added.  Check out `/logs` and search for `[akismet]`.  It will log when the job started running and info about posts that it found that it believes are spam.

For testing purposes, you can also trigger the job whenever you want by going to `/sidekiq/scheduler` if you are an admin.  Look for a job called `CheckForSpamPosts`


This project uses MIT-LICENSE.
