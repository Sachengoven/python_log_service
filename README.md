QUESTION :
Engineering Task: Developing a Simple Log Service

Objective:
Develop a simple log service application using serverless functions.

Requirements:

The solution should be entirely IAC driven.
Create two serverless functions using AWS Lambda or Azure Functions:
Function 1: Receives a log entry and saves it.
Function 2: Retrieves the 100 most recent log entries.
Log Entry Format:
Each log entry should contain the following fields:
ID: Unique identifier for the log entry.
Date Time: Timestamp for when the log was created.
Severity: One of info,  warning, or error.
Message: The actual log message.
Functionality:  
Function 1 should expose an API endpoint to receive log entries and store them.
Function 2 should expose an API that returns the last 100 log entries in JSON format, sorted by most recent.
General Requirements:
Write the solution in a language of your choice.
Ensure the code is well-documented, follows best practices, and is easy to understand.
Push the solution to a GitHub repository and create a pipeline, with clear instructions on how to deploy and run the functions.
Ensure you follow least privilege principles.
Utilize encryption to secure your data.
Make sure your credentials are secured.
Ensure the pipeline authenticates securely to AWS or Azure using best practices.
Add security checks to your pipeline.
Consider security of your API

SOLUTION :
This Terraform code establishes the infrastructure for a log service on AWS. Key components include:

* Lambda Function Deployment: Packaging and deploying the code for the Lambda functions.
* Secure Log Data Storage: Storing log data in an encrypted DynamoDB table, with encryption enabled via KMS.
* API Access: Providing an API endpoint (API Gateway) for interacting with the log service.
* API Security: Securing the API with a Web ACL (WAF).
* Due to Terraform technical issues, the WAF ACL could not be associated with the API Gateway.
* In a production environment, Terraform state should be managed more securely, ideally by storing it in AWS S3 by configuring the backend or using Terraform Cloud.

For testing purposes, I utilized an A Cloud Guru Cloud Sandbox environment, which is usually deleted after a few hours
