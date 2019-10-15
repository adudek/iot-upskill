var awsIot = require('aws-iot-device-sdk');

var thingName = 'something'
var device = awsIot.device({
   keyPath: '../terraform/out/certificate.key',
  certPath: '../terraform/out/certificate.pem',
    caPath: './res/AmazonRootCA1.pem',
  clientId: 'iot1',
      host: 'a3d4t1k4jdzfpu-ats.iot.eu-central-1.amazonaws.com'
});

device
  .on('connect', function() {
    var payload = { test_cert: 1 };
    device.subscribe(thingName);
    device.publish(thingName, JSON.stringify(payload));
    console.log('published:', payload)
  });

device
  .on('message', function(topic, payload) {
    console.log('received:', topic, payload.toString());
  });
