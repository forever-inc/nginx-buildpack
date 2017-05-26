# Forever Nginx Buildpack

Nginx-buildpack vendors NGINX inside a dyno and connects NGINX to an app server via UNIX domain sockets.

## Motivation

Run Nginx as a reverse-proxy to other apps running on separate Heroku instances.  All of the buildpacks out there
are out of date, and almost all are designed to run Nginx on the same server as your app and wait for your app to
start up before enabling Nginx.  Also, most don't include the SSL modules, which we need.  

This buildpack is based on the repo located at: https://github.com/ryandotsmith/nginx-buildpack 

## Building the Binary

In order to build the binary, this repo needs to be deployed to Heroku as an app, specifying itself as the
buildpack. Choose the stack for which you need the binary built when creating the Heroku app.

It will then make the binary available for you to download from the root of the app's webpage as `nginx`.  Once built, 
you can download the binary, rename it to end in the name of the stack (eg `nginx-heroku-16`), make it executable by
performing `chmod 744` and then commit it to the /bin directory of the repo, to make it available for consumers of
the buildpack.

It will build from source if it doesn't find the binary matching the stack.

To change the version of Nginx or any of the compile options, edit the `/bin/compile_from_source.sh` file.

Note: due to changes in the Heroku-16 stack, the necessary compile tools are no longer available at runtime and are
required in order to build the binary, so this is done in the compile phase.  As such, you don't have access to the
app's ENV variables to select versions of each module like you did in the referenced buildpack above.  The file 
`nginx_buildpack_compile_log` will be added to your app's directory logging the output of the buildpack 
(actual nginx compile will be in the terminal, but with so much noise, this file gives a summary of your app's compile).

## Using the Buildpack

To use this buildpack, add it to your app.  Create a `config` directory in the root of the application.  Put
your custom `nginx.conf.erb` file here.  You can also add a custom `mime.types` file.  If present, the buildpack
will use your files to configure Nginx when deploying.

When your app is deployed, if it finds an appropriate binary in the buildpack for your app's stack, it will use the
binary from the buildpack.  Otherwise, it will just build it from source during the compile phase of your app.

Add the following line to your app's Procfile to start Nginx with your app:
```apple js
web: bin/start-nginx
```

## Versions

* Buildpack Version: 0.1
* NGINX Version: 1.13.0
* PCRE Version: 8.40
* HEADERS_MORE Version: 0.32
* Includes Binaries for stacks: `cedar-14`, `heroku-16`