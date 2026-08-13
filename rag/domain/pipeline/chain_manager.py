import logging
from langchain_openai import OpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser

from core import RAGSettings, DocumentFormat

logger = logging.getLogger(__name__)
settings = RAGSettings()


class RAGChainManager:
    @staticmethod
    def build_chain(retriever):
        logger.info("<--- Pipeline Started --->")
        return (
            {
                "context": retriever | DocumentFormat.format_docs,
                "question": RunnablePassthrough(),
            }
            | ChatPromptTemplate.from_template("""
            You are a medical assistant for informational purposes only.
            Answer the question based only on the following context:
            {context}

            Question: {question}

            Make sure to answer in a concise manner,
            and if you don't know the answer, just say "I Dont't Know."
              """)
            | OpenAI(model=settings.LLM_MODEL_NAME, api_key=settings.OPENAI_API_KEY)
            | StrOutputParser()
        )
