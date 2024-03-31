from pymongo import MongoClient
from langchain_openai import OpenAIEmbeddings
from langchain_community.vectorstores import MongoDBAtlasVectorSearch
from langchain_community.document_loaders import TextLoader, JSONLoader, DirectoryLoader
from langchain_community.llms import OpenAI
from langchain.chains import RetrievalQA
import gradio as gr
from gradio.themes.base import Base
import key_param
from pprint import pprint

client = MongoClient(key_param.MONGO_URI)
dbName = "yoyak"
collectionName = "medicine_detail_vector"
collection = client[dbName][collectionName]

loader = JSONLoader(
    file_path="./medicine/medicine_details.json",
    jq_schema=".",
    text_content=False,
)

data = loader.load()

embeddings = OpenAIEmbeddings(openai_api_key=key_param.openai_api_key,model="text-embedding-3-small")

vectorStore = MongoDBAtlasVectorSearch.from_documents(data, embeddings, collection=collection)

