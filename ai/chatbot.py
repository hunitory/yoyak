from langchain_core.pydantic_v1 import BaseModel, Field
import pydantic
from dotenv import load_dotenv
from langchain_core.output_parsers import JsonOutputParser
from langchain.prompts import PromptTemplate
from langchain_core.prompts.chat import (
    ChatPromptTemplate,
    HumanMessagePromptTemplate,
    SystemMessagePromptTemplate,
)
from langchain_openai import ChatOpenAI
import json
from typing import Optional
import os

class MessageResponseDto(BaseModel):
    efficacy: Optional[str] = None
    sideEffects: Optional[str] = None
    howToTake: Optional[str] = None
    storageInstructions: Optional[str] = None



load_dotenv()
os.environ["OPENAI_API_KEY"] =  os.getenv("OPENAI_API_KEY")
os.environ["ANTHROPIC_API_KEY"] = os.getenv("ANTHROPIC_API_KEY")

def get_content_using_llm(message):
    print(message)
    print("OPENAI_API_KEY", os.environ["OPENAI_API_KEY"])
    model = ChatOpenAI(temperature=0, openai_api_key=os.environ["OPENAI_API_KEY"], model_name="gpt-4")
    
    parser = JsonOutputParser(pydantic_object=MessageResponseDto)
    try:
        if not message or message.strip() == "":
            raise ValueError("약에 대한 정보가 없습니다")
        prompt = PromptTemplate(
            template = """You are a helpful pharmacist. Please tell me about the efficacy, side effects, how to take, and storage instructions of the medicine in Korean. 
                          If there is no medicine information, return 'No medicine'  \n{format_instructions}\n{message}""",
            input_variables=["message"],
            partial_variables={"format_instructions": parser.get_format_instructions()}
        )

        chain = prompt | model | parser
        content = chain.invoke(message)
        # print(content)
        return content
    except ValueError as ve:
        print(ve)
        return {
            "error": ve
        }

    except Exception as e:
        print(e)
        return {
            "error": e
        }


import uvicorn
from fastapi import FastAPI, Request
from urllib.parse import unquote

app = FastAPI();
@app.get("/python/chatbot")
async def chatbot(request: Request):
    message = request.query_params.get("message")
    message = unquote(message)

    
    content = get_content_using_llm(message)

    return content;

if __name__ == "__main__":
    # get_content_using_llm("paracetamol");
    uvicorn.run("chatbot:app", host="0.0.0.0", port=8000, reload=True)