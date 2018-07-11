#!/bin/bash

echo "vac pub_queue";
. $HOME/.bash_profile;
. $HOME/.bashrc;

alias heroku="/usr/local/bin/heroku"

# check we have the needed heroku
heroku --version

heroku ps:scale update=0 --app=oadoi

heroku pg:killall --app=oadoi

psql $DATABASE_URL -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE state = 'idle in transaction'";
psql $DATABASE_URL -c "vacuum full verbose analyze pub_queue"

heroku ps:scale update=30 --app=oadoi
