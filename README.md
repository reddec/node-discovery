node-discovery
==============

Simple UDP multicast node discovery

Emits events with name of catched service description

Custom event '\*' catches all messages (except own or force)

Example
-------

~~~~ {.javascript}
var Description = require('../lib/service').Description;
var Listener = require('../lib/service').Listener;

//Create listener of announced notifications
var listener = new Listener();

//Generate unique client name
var serviceName = 'service-' + Math.random();

//Create new service
var service = new Description(serviceName);

//Add some meta info
service.attr('author', 'reddec');

//Add listeners for all messages
listener.on('*', function(serviceName, ip, data) {
  console.log("Service", serviceName, "found from", ip, ":", data);
});
~~~~

API
---

Constants
=========

-   `MULTICAST_PORT = 22000`
-   `MULTICAST_IP = '239.155.155.150'`
-   `MULTICAST_INTERVAL = 2000`

class Description
=================

Contains description of service and announce it periodically

[constructor]
-------------

    Description(name, port = MULTICAST_PORT, ip = MULTICAST_IP, interval = INTERVAL)

Create new instance of service description and starts announcing

-   `name {string}` Name of service
-   `port {number}` Multicast port
-   `ip {string}` Multicast IP
-   `interval {number}` Sending interval in ms

attr
----

    attr:(name, data)

Add attribute of description. Same name will be replaced

-   `name {string}` Name of attribute
-   `data {object}` Serializeable description
-   return itself

close
-----

    close:()

Close sockets and remove all listeners and timers

-   return itself

notify
------

    notify:()

Send self description to multicast group

-   return itself

class Listener extends EventEmitter
===================================

Simple service discovery over UDP multicast. Emits events with name of
catched service description. Custom event '\*' catches all messages

[constructor]
-------------

    Listener(done, port = MULTICAST_PORT, ip = MULTICAST_IP, interval = INTERVAL)

Create new instance of service finder

-   `done {function(Listener)}` Ready callback
-   `port {number}` Multicast port
-   `ip {string}` Multicast IP

on\_message
-----------

    on_message:(msg, rinfo)

Listener function for incoming UDP messages

close
-----

    close:()

Close sockets and remove all listeners and timers

-   return itself
