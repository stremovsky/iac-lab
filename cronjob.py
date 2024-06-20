import requests
import datetime
import socket
import boto3
import json
import os

load1, load5, load15 = os.getloadavg()

current_date = datetime.datetime.now().strftime("%d-%m-%Y")
hostname = socket.gethostname()
url = "https://webhook.site/2b41a624-7f1d-4820-8c0d-987e23d59c6b"
data = {
    "current_date": current_date,
    "hostname": hostname,
    "la": {
      "1m": load1,
      "5m": load5,
      "15m": load15
    }
}
json_data = json.dumps(data)
print(json_data)
headers = {
    "Content-Type": "application/json"
}
response = requests.post(url, data=json_data, headers=headers)
print("Status Code", response.status_code)
print("Response Text", response.text)
s3 = boto3.client('s3')
print(s3.list_buckets())
s3.put_object(Bucket='demo-stack-1-bucket', Key='file.txt', Body=str(response.status_code))
