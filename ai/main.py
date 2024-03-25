import uvicorn
from fastapi import FastAPI, UploadFile, Request, status, File
from fastapi.responses import JSONResponse, FileResponse
import os
import uuid
from pathlib import Path
import sys
import platform
import json



from predict import run;
app = FastAPI()

FILE = Path(__file__).resolve()
ROOT = FILE.parents[0]  # YOLO root directory
if str(ROOT) not in sys.path:
    sys.path.append(str(ROOT))  # add ROOT to PATH
ROOT = Path(os.path.relpath(ROOT, Path.cwd()))  # relative
print("Hello")

from starlette.middleware.cors import CORSMiddleware

origins = [
    "https://j10b102.p.ssafy.io",
    "http://localhost:8000",
    "http://0.0.0.0:8000",
    "http://0.0.0.0",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/python/test")
def test():
    return "test"


@app.post("/python/upload")
async def upload_file(image: UploadFile = File(...)):
    extension = os.path.splitext(image.filename)[1]
    unique_name = f"{uuid.uuid4()}{extension}"

    upload_path = "uploads"
    if not os.path.exists(upload_path):
        os.makedirs(upload_path)
    file_path = os.path.join(upload_path, unique_name)
    with open(file_path, "wb") as buffer:
        buffer.write(image.file.read())
    
    option = {
        "weights":ROOT / './trained_model/2515_2659_1224_109.pt',
        "source" : file_path,
        "data": ROOT/'data/custom.yaml',
        "imgsz" : [640,640],
        "device" : "cpu"
    }


    # option = {
    #     "weights":ROOT / './trained_model/2515_2659_2066_1224_2558_109.pt',
    #     "source" : "https://yoyak.s3.ap-northeast-2.amazonaws.com/1.jpg",
    #     "data": ROOT/'data/custom.yaml',
    #     "imgsz" : [640,640],
    #     "device" : "cpu"
    # }
    print("option", option)
    names = run(**option)

    medicineList = []
    for name in names:
        data = {}
        splited = name.split("-")
        data["medicineCode"] = splited[0]
        data["medicineName"] = splited[1]
        medicineList.append(data)

    


    return {
        "count": len(names),
        "medicineList": medicineList
    }



import pydantic


class SummaryRequestDto(pydantic.BaseModel):
    itemName : str
    atpn : str
    efficacy : str
    useMethod : str
    depositMethod : str
    sideEffect : str

from summary import get_content_using_llm;


@app.post("/python/summary")
async def summary(summaryRequestDto: SummaryRequestDto):

    content = get_content_using_llm(summaryRequestDto)
    print(type(content))
    print(content)

    return {
        "summary" : content["summary"]
    }





if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
