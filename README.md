node-discovery
==============

Simple UDP multicast node discovery

Emits events with name of catched service description

Custom event '*' catches all messages (except own or force)

Example
---------------

```javascript
var Service = require('service-discovery');

//Generate unique client name
var serviceName = 'service-' + Math.random();

//Create new service
var service = new Service(serviceName);

//Add some meta info
service.add('object1', {
  author: 'reddec'
});

//Add listeners for all messages
service.on('*', function(serviceName, ip, data) {
  console.log("Service", serviceName, "found from", ip, ":", data);
});

//Force request info
service.force();
```

API
----------------

# Constants

* `MULTICAST_PORT = 22000`
* `MULTICAST_IP = '239.155.155.150'`
* `MULTICAST_INTERVAL = 2000`

## [constructor]

```
Service(name, port = MULTICAST_PORT, ip = MULTICAST_IP, interval = INTERVAL)
```

Create new instance of discovery service, join to muticast and start regular sending

* `name {string}` Name of service. Messages from services with same name will not be catched
* `port {number}` Multicast port
* `ip {string}` Multicast IP
* `interval {number}` Sending interval in ms


## on_message

```
on_message: (msg, rinfo)
```

Listener for incoming UDP messages


## add

```
add:(name, data)
```

Add new service (logical) description. Same name will be replaced

* `name {string}` Name of logical service
* `data {object}` Serializeable description
* return itself


## force

```
force:()
```

Force request descriptions from remote services

* return itself


## forceByName

```
forceByName:(name)
```

Force request descriptions from service with specified name

* `{string} name` Name of service
* return itself

## close

```
close:()
```

Close sockets and remove all listeners

* return itself

## sendAbout

```
sendAbout:()
```

Send self description to multicast group

* return itself
