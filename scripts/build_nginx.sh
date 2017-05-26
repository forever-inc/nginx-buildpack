#!/bin/bash
# Build NGINX and modules on Heroku.
# When deployed as 'an app', this Procfile will be executed and the
# compiled Nginx binary will be available to download from the root web page
#
# Before deployment, delete the binary for your Heroku stack so that the
# script will build a new one.  If it finds a binary in /bin, it won't build new.
#
# Once the dyno has is 'up' you can open your browser and navigate
# this dyno's directory structure to download the nginx binary.
#
# Once downloaded, rename it to match the Heroku stack name and copy it into the
# buildpack's /bin directory.  Mark it as executable with 'chmod 744 nginx-STACKNAME'
# then commit and push to GitHub.  Now your buildpack will be useable on that stack
# without paying the download/compile time penalty.

temp_dir=$(mktemp -d /tmp/nginx.XXXXXXXXXX)

echo "Serving files from /tmp on $PORT"
cd /tmp
python -m SimpleHTTPServer $PORT &

cp ~/bin/nginx "/tmp/nginx"

while true
do
	sleep 1
	echo "."
done
