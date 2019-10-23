var awsIot = require('aws-iot-device-sdk');

var thingName = 'anything'
var thingShadows = awsIot.thingShadow({
   keyPath: '../terraform/out/certificate.key',
  certPath: '../terraform/out/certificate.pem',
    caPath: './res/AmazonRootCA1.pem',
  clientId: 'iot2',
      host: 'a3d4t1k4jdzfpu-ats.iot.eu-central-1.amazonaws.com'
});

thingShadows.on('connect', function() {
  thingShadows.register(thingName, {}, function() {
    var newState = { state: { reported: { newstatedatenow: Date.now() } } };
    var updateToken = thingShadows.update(thingName, newState);
    console.log('new state:', newState);
    console.log('update token:', updateToken);
  });


  thingShadows.on('update', function(thingName, stateObject) {
    console.log('received update ' + ' on ' + thingName + ': ' + JSON.stringify(stateObject));
  });

  thingShadows.on('status', function(name, stat, clientToken, stateObject) {
    console.log(Date.now(), 'received ' + stat + ' on ' + name + ': ' + JSON.stringify(stateObject));
  });

  thingShadows.on('delta', function(thingName, stateObject) {
    console.log('received delta ' + ' on ' + thingName + ': ' + JSON.stringify(stateObject));
  });

  thingShadows.on('timeout', function(thingName, clientToken) {
    console.log('received timeout for '+ clientToken)
  });

  thingShadows.on('close', function() {
    console.log('close');
  });

  thingShadows.on('reconnect', function() {
    console.log('reconnect');
  });

  thingShadows.on('offline', function() {
    console.log('offline');
  });

  thingShadows.on('error', function(error) {
    console.log('error', error);
  });
});
