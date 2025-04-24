from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
import sys
sys.path.append('./src') 
from src.phoBert import PhoBertNER

# Định nghĩa schema đầu vào/ra
class TextRequest(BaseModel):
    text: str

class TaskEntity(BaseModel):
    entity: str
    type: str

class NerResponse(BaseModel):
    tasks: List[TaskEntity]

# Khởi tạo ứng dụng và load model
app = FastAPI()
ner_model = PhoBertNER()

# API health check
@app.get("/health")
async def health_check():
    return {"status": "ok"}

@app.post("/extract-tasks", response_model=NerResponse)
async def extract_tasks(request: TextRequest):
    """API trích xuất công việc từ văn bản họp"""
    results = ner_model.predict(request.text)
    
    return {
        "tasks": [
            {
                "entity": ent["entity"],
                "type": ent["type"],
            }
            for ent in results
        ]
    }


