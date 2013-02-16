ID Service
==========

This gem provides both client and server classes for running an ID generation service, based on the Thrift framework.
The overall architecture is based on Twitter's Snowflake service, but written in Ruby. The core ID Generator is very
fast (10,000 IDs/sec) and the server is designed to be very fast as well (1,000 IDs/sec).

**WARNING** :: The IDs returned by the server, whether you use the pre-built one or customize will always return
sequential and unique IDs, except in the case that you run multiple servers with the same host and worker identifiers.
In that case you will not be guaranteed uniqueness of the IDs.

Running the Server
------------------

This gem comes with a pre-made server executable that can be used in lieu of building your own server implementation. To
start the provided server simple run the following command:

    id_server

The server is designed to run in the foreground by default. It also accepts a number of options. You can check the
available options by passing the `--help` switch to the command.

Custom Server
-------------

Some may want to build their own server implementation. This is very simple. Just pass the relevant options when
initializing an instance of IdService::Server and then call `#serve` on your server instance.

    require 'id_service/server'

    options = {
      hostname: 'localhost',
      port:     9000,
      host:     1,
      worker:   1,
      debug:    false
    }

    server = IdService::Server.new(options)
    server.serve

That's all there is to it.

Using the Client
----------------

Using the client is just as easy. If your server is running on localhost and port 9000 you can skip supplying the
options to client initialization.

    require 'id_service'

    options = {
      host: 'localhost',
      port: 9000
    }

    client = IdService::Client.new(options)
    client.open

    client.get_id

The `#get_id` method will always return sequential and unique IDs, given you don't have multiple servers using the same
host and worker identifiers responding to multiple clients.
