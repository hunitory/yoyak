from langchain_core.pydantic_v1 import BaseModel, Field
import pydantic
from dotenv import load_dotenv
from langchain_core.output_parsers import JsonOutputParser
from langchain.prompts import PromptTemplate
from langchain_openai import ChatOpenAI
import json
import os


class SummaryResponseDto(BaseModel):
    summary : str

load_dotenv()
os.environ["OPENAI_API_KEY"] =  os.getenv("OPENAI_API_KEY")
os.environ["ANTHROPIC_API_KEY"] = os.getenv("ANTHROPIC_API_KEY")

def get_content_using_llm(summaryRequestDto):
    print("OPENAI_API_KEY", os.environ["OPENAI_API_KEY"])
    model = ChatOpenAI(temperature=0, openai_api_key=os.environ["OPENAI_API_KEY"], model_name="gpt-3.5-turbo")

    parser = JsonOutputParser(pydantic_object=SummaryResponseDto)

    prompt = PromptTemplate(
        template="""Summarize the following infomation using {format_instruction} format in 20 characters or less. 
                    warning: {atpn}, efficacy: {efficacy}, useMethod: {useMethod} depositMethod: {depositMethod} sideEffect: {sideEffect}""",
        input_variables=["atpn", "efficacy", "useMethod", "depositMethod", "sideEffect"],
        partial_variables={"format_instruction": parser.get_format_instructions()}    
    )

    chain = prompt | model | parser

    content = chain.invoke({
        "atpn": summaryRequestDto.atpn,
        "efficacy": summaryRequestDto.efficacy,
        "useMethod": summaryRequestDto.useMethod,
        "depositMethod": summaryRequestDto.depositMethod,
        "sideEffect": summaryRequestDto.sideEffect
    })

    return content;