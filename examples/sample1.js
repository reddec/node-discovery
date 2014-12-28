var Service = require('../lib/service');

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