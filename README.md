# Akismet Plugin for Discourse Forum

## Spam Sucks, Fight it with Akismet

Discourse is great, but spam can be a problem. [Akismet](http://akismet.com/) is a well known service that has an
algorithm for detecting spam.  Akismet is NOT free for commerical use, but can be for personal use.  To use this 
plugin you will need an Akismet API key.  You can get a key by starting out [here](http://akismet.com/plans/).

## How it Works
The plugin works by creating a new table where we collect info about a new post's http request.  After the post is created 
we link that data with the post.  Every 10 minutes a background jobs run which looks for posts that were created in the last 12 minutes.
All new posts are sent to Akismet to determine if they are spam or not.  If a post is deemed spam, it is deleted and placed in
a moderator queue where admins can take action against it.


## Setup

If you don't have the migrations copied over, run the following
````
rake akismet:install:migrations
rake db:migrate SCOPE=akismet
````

You also need the akismet api key set as an ENV variable
````
export AKISMET_KEY=''
````


This project uses MIT-LICENSE.
