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
    print("summaryRequestDto: ", summaryRequestDto)
    print("OPENAI_API_KEY", os.environ["OPENAI_API_KEY"])
    model = ChatOpenAI(temperature=0, openai_api_key=os.environ["OPENAI_API_KEY"], model_name="gpt-3.5-turbo")

    parser = JsonOutputParser(pydantic_object=SummaryResponseDto)

    template = """Summarize the following information using {format_instruction} format in 20 characters or less."""
    if summaryRequestDto.atpn:
        template += " warning: {atpn},"
    if summaryRequestDto.efficacy:
        template += " efficacy: {efficacy},"
    if summaryRequestDto.useMethod:
        template += " useMethod: {useMethod},"
    if summaryRequestDto.depositMethod:
        template += " depositMethod: {depositMethod},"
    if summaryRequestDto.sideEffect:
        template += " sideEffect: {sideEffect}"

    prompt = PromptTemplate(
        template=template,
        input_variables=["atpn", "efficacy", "useMethod", "depositMethod", "sideEffect"],
        partial_variables={"format_instruction": parser.get_format_instructions()}    
    )

    chain = prompt | model | parser

    input_data = {}
    if summaryRequestDto.atpn:
        input_data["atpn"] = summaryRequestDto.atpn
    if summaryRequestDto.efficacy:
        input_data["efficacy"] = summaryRequestDto.efficacy
    if summaryRequestDto.useMethod:
        input_data["useMethod"] = summaryRequestDto.useMethod
    if summaryRequestDto.depositMethod:
        input_data["depositMethod"] = summaryRequestDto.depositMethod
    if summaryRequestDto.sideEffect:
        input_data["sideEffect"] = summaryRequestDto.sideEffect

    content = chain.invoke(input_data)

    return content