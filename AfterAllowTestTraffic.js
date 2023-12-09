'use strict';
 
 const AWS = require('aws-sdk');
 const codedeploy = new AWS.CodeDeploy({apiVersion: '2014-10-06'});
 const https = require("http");
 
 exports.handler = (event, context, callback) => {
 
 	console.log("Entering AfterAllowTestTraffic hook.");
 	
 	// Read the DeploymentId and LifecycleEventHookExecutionId from the event payload
  var deploymentId = event.DeploymentId;
 	var lifecycleEventHookExecutionId = event.LifecycleEventHookExecutionId;
 	var validationTestResult;
 	
 	// Perform AfterAllowTestTraffic validation tests here. Set the test result 
 	// to "Succeeded" for this tutorial.
 	console.log("This is where AfterAllowTestTraffic validation tests happen.");
 	//validationTestResult = "Succeeded";
 	
 	
 	
 	
 	let url = "http://2191420-cohort-demo-alb-884195078.us-east-1.elb.amazonaws.com:8080/";
 	let statusCode;

 	https.get(url, (res) => {
    statusCode = res.statusCode;
    if (statusCode === 200) {
      validationTestResult = "Succeeded";
      console.log("URL: ",url);
      console.log("URL Status Code: " , statusCode);
      console.log("Validation Result: ", validationTestResult);
      var params = {
 		deploymentId: deploymentId,
 		lifecycleEventHookExecutionId: lifecycleEventHookExecutionId,
 		status: validationTestResult // status can be 'Succeeded' or 'Failed'
 	};
 	
 	codedeploy.putLifecycleEventHookExecutionStatus(params, function(err, data) {
 		if (err) {
 			// Validation failed.
 			console.log("Parameters: ", params);
 			console.log('AfterAllowTestTraffic validation tests failed');
 			console.log(err, err.stack);
 			callback("CodeDeploy Status update failed");
 		} else {
 			// Validation succeeded.
 			console.log("Parameters: ", params);
 			console.log("AfterAllowTestTraffic validation tests succeeded");
 			callback(null, "AfterAllowTestTraffic validation tests succeeded");
 		}
 	});
    } else {
      validationTestResult = "Failed";
      console.log("URL: ",url);
      console.log("URL Status Code: " , statusCode);
      console.log("Validation Result: ", validationTestResult);
     var params = {
 		deploymentId: deploymentId,
 		lifecycleEventHookExecutionId: lifecycleEventHookExecutionId,
 		status: validationTestResult // status can be 'Succeeded' or 'Failed'
 	};
 	
 	codedeploy.putLifecycleEventHookExecutionStatus(params, function(err, data) {
 		if (err) {
 			// Validation failed.
 			console.log("Parameters: ", params);
 			console.log('AfterAllowTestTraffic validation tests failed');
 			console.log(err, err.stack);
 			callback("CodeDeploy Status update failed");
 		} else {
 			// Validation succeeded.
 			console.log("Parameters: ", params);
 			console.log("AfterAllowTestTraffic validation tests succeeded");
 			callback(null, "AfterAllowTestTraffic validation tests succeeded");
 		}
 	});
  }
  }).on("error", (e) => {
      callback(Error(e));
    });
 	
 	
 }  
 