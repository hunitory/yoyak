from langchain_core.pydantic_v1 import BaseModel, Field
import pydantic
from dotenv import load_dotenv
from langchain_core.output_parsers import JsonOutputParser
from langchain.prompts import PromptTemplate
from langchain_openai import ChatOpenAI
import json
from typing import Optional
import os

class SummaryRequestDto(pydantic.BaseModel):
    itemName : str
    atpn : Optional[str] = None
    efficacy : Optional[str] = None
    useMethod : Optional[str] = None
    depositMethod : Optional[str] = None
    sideEffect : Optional[str] = None

    def __str__(self):
        return f"itemName: {self.itemName}\n" \
               f"atpn: {self.atpn}\n" \
               f"efficacy: {self.efficacy}\n" \
               f"useMethod: {self.useMethod}\n" \
               f"depositMethod: {self.depositMethod}\n" \
               f"sideEffect: {self.sideEffect}"



class SummaryResponseDto(BaseModel):
    summary : str

load_dotenv()
os.environ["OPENAI_API_KEY"] =  os.getenv("OPENAI_API_KEY")
# os.environ["ANTHROPIC_API_KEY"] = os.getenv("ANTHROPIC_API_KEY")

def get_content_using_llm(summaryRequestDto):
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



if __name__ == "__main__":
    dto = SummaryRequestDto(
        itemName="광동네모파스카타플라스마",
        atpn="눈주위, 점막, 습진, 옻 등에 의한 피부염, 상처부위 등에 사용하지 마십시오",
        efficacy = "이 약은 요통, 타박상, 삠, 어깨결림, 관절통, 근육통, 근육피로, 동창(언 상처), 골절통의 진통·소염(항염)에 사용합니다.",
        useMethod = None,
        depositMethod = "어린이의 손이 닿지 않는 곳에 보관하십시오",
        sideEffect="발진·발적(충혈되어 붉어짐), 가려움 등이 나타나는 경우 사용을 즉각 중지하고 의사 또는 약사와 상의하십시오."
    )

    content = get_content_using_llm(dto)
    print(content["summary"])