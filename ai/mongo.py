from pymongo import MongoClient

client = MongoClient("mongodb+srv://polya:tollea1324@cluster0.qhkasr9.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")

db = client.get_database('yoyak')

medicines = list(db.medicine.find({},{"_id":False}))

medicine_details = list(db.medicine_detail.find({"seq":201601324},{"_id":False}))

temp = medicine_details[0]
print(temp)
                        

                        
    

