import json
import boto3
import os
import uuid  

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMODB_TABLE_NAME']
table = dynamodb.Table(table_name)

def handler(event, context):
    try:
        body = json.loads(event['body'])
        # Generate a unique ID for the log entry
        id = str(uuid.uuid4())
        timestamp = body['timestamp']
        severity = body['severity']
        message = body['message']

        # Basic input validation
        if not isinstance(timestamp, (int, float)):
            return {
                'statusCode': 400,
                'body': json.dumps('Error: timestamp must be a number')
            }
        if severity not in ['info', 'warning', 'error']:
            return {
                'statusCode': 400,
                'body': json.dumps('Error: severity must be one of info, warning, or error')
            }
        if not isinstance(message, str):
             return {
                'statusCode': 400,
                'body': json.dumps('Error: message must be a string')
            }

        response = table.put_item(
           Item={
                'id': id,
                'timestamp': timestamp,
                'severity': severity,
                'message': message
            }
        )
        return {
            'statusCode': 200,
            'body': json.dumps('Log entry stored successfully!')
        }
    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'body': json.dumps('Error: Invalid JSON in request body')
        }
    except Exception as e:
        print(f"Error storing log entry: {e}")  # Log the error for debugging
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error storing log entry: {str(e)}')
        }