var awsIot = require('aws-iot-device-sdk');

var device = awsIot.device({
   keyPath: '../terraform/out/cert/private.pem.key',
  certPath: '../terraform/out/cert/certificate.pem.crt',
    caPath: '../terraform/out/cert/root-CA.crt',
  clientId: 'iot1',
      host: 'a3d4t1k4jdzfpu-ats.iot.eu-central-1.amazonaws.com'
});

device
  .on('connect', function() {
    console.log('connect');
    device.subscribe('test');
    device.publish('test', JSON.stringify({ test_cert: 1}));
  });

device
  .on('message', function(topic, payload) {
    console.log('message', topic, payload.toString());
  });
