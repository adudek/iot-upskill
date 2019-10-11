var awsIot = require('aws-iot-device-sdk');

var device = awsIot.device({
   keyPath: '../terraform/out/certificate.key',
  certPath: '../terraform/out/certificate.pem',
    caPath: './res/AmazonRootCA1.pem',
  clientId: 'iot1',
      host: 'a3d4t1k4jdzfpu-ats.iot.eu-central-1.amazonaws.com'
});

console.log(device);

device
  .on('connect', function() {
    console.log('connect');
    device.subscribe('something');
    device.publish('something', JSON.stringify({ test_cert: 1 }));
  });

device
  .on('message', function(topic, payload) {
    console.log('message', topic, payload.toString());
  });
