import boto3
import json
from datetime import datetime

def lambda_handler(event, context):
    ses = boto3.client('ses')
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    sender_email = 'nada.khater.abdu@gmail.com'
    recipient_email = 'nada.khater.abdu@gmail.com'

    subject = 'A New Change Detected in Your State File!'
    body = f"State file change detected in your application.\nTime: '{current_time}'"

    response = ses.send_email(
        Source=sender_email,
        Destination={'ToAddresses': [recipient_email]},
        Message={
            'Subject': {'Data': subject},
            'Body': {'Text': {'Data': body}}
        }
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Email sent successfully')
    }