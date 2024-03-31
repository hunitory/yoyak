from pymongo import MongoClient


import json
import os

client = MongoClient("mongodb+srv://polya:tollea1324@cluster0.qhkasr9.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")
db = client.get_database('yoyak')

file_path = "./medicine"

if not os.path.exists(file_path):
    os.makedirs(file_path)

json_file_path = "./medicine_detail.json"
with open(json_file_path, 'r', encoding='utf-8') as file:
    json_data = file.readlines()

# JSON 객체를 리스트로 변환
medicine_details = []
for json_str in json_data:
    medicine_detail = json.loads(json_str)
    del medicine_detail['_id']
    del medicine_detail["seq"]
    medicine_details.append(medicine_detail)

# 결과를 하나의 JSON 파일로 저장
output_file_path = "./medicine/medicine_details.json"
with open(output_file_path, 'w', encoding='utf-8') as file:
    json.dump(medicine_details, file, ensure_ascii=False, indent=4)

print("JSON file created successfully.")