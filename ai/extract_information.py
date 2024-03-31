from pymongo import MongoClient
from langchain_openai import OpenAIEmbeddings
from langchain_community.vectorstores import MongoDBAtlasVectorSearch
from langchain_community.document_loaders import TextLoader, JSONLoader, DirectoryLoader,MongodbLoader
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_community.embeddings import OllamaEmbeddings
from langchain.chains import RetrievalQA
import gradio as gr
from gradio.themes.base import Base
import key_param
from pprint import pprint
import os 

# client = MongoClient(key_param.MONGO_URI)
# dbName = "yoyak"
# collectionName = "medicine_detail_vector"
# collection = client[dbName][collectionName]
# os.environ["GOOGLE_API_KEY"] = key_param.GOOGLE_API_KEY
# loader = JSONLoader(
#     file_path="./medicine/medicine_details.json",
#     jq_schema=".",
#     text_content=False,
# )

# data = loader.load()
# print(len(data))
# # embeddings = OpenAIEmbeddings(openai_api_key=key_param.openai_api_key,model="text-embedding-3-small")
# # embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")

# # vectorStore = MongoDBAtlasVectorSearch.from_documents(data, embeddings, collection=collection)

loader = MongodbLoader(
    connection_string=key_param.MONGO_URI,
    db_name="yoyak",
    collection_name="medicine_detail"
)

docs = loader.load()

print(len(docs))
print(docs[0])