#!/bin/sh

echo 'running db setup'
rake db:setup

echo 'running db migration'
rails db:migrate

echo 'clearing pids'
rm -f tmp/pids/server.pid;

echo 'running ruby server'
rails server --binding=0.0.0.0
