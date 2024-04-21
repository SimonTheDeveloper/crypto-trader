import boto3
import requests
import json
from datetime import datetime
import os

# Define the S3 bucket name
bucket_name = 'binance-data-kamia'

# Define the Binance API endpoint
binance_api_url = os.environ['BINANCE_API_URL']

# Initialize the S3 client
s3 = boto3.client('s3')

def fetch_data_from_binance():
    response = requests.get(binance_api_url)
    data = response.json()
    return data

def upload_data_to_s3(data):
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    file_name = f'binance_data_{timestamp}.json'
    with open(file_name, 'w') as file:
        json.dump(data, file)
    s3.upload_file(file_name, bucket_name, file_name)

def lambda_handler(event, context):
    data = fetch_data_from_binance()
    upload_data_to_s3(data)