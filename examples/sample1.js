var Description = require('../lib/service').Description;
var Listener = require('../lib/service').Listener;
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