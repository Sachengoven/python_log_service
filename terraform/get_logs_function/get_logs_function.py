import json
import boto3
import os
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMODB_TABLE_NAME']
table = dynamodb.Table(table_name)

def handler(event, context):
    try:
        response = table.scan()
        items = response['Items']

        # Convert Decimal values to standard Python types before sorting
        for item in items:
            if 'timestamp' in item and isinstance(item['timestamp'], Decimal):
                item['timestamp'] = int(item['timestamp']) # Or float(item['timestamp'])

        # Sort the items by timestamp in descending order (most recent first)
        sorted_items = sorted(items, key=lambda x: x['timestamp'], reverse=True)

        # Get the last 100 items, or all items if there are fewer than 100
        last_100_items = sorted_items[:100]

        return {
            'statusCode': 200,
            'body': json.dumps(last_100_items)
        }
    except Exception as e:
        print(f"Error retrieving log entries: {e}") # Log the error
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error retrieving log entries: {str(e)}')
        }