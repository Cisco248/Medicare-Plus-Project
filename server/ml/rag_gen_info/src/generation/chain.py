import logging
from langchain_core.output_parsers import JsonOutputParser
from pydantic import SecretStr
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough
from langchain_openai import ChatOpenAI
from constants import Settings

logger = logging.getLogger(__name__)
settings = Settings()

from pydantic import BaseModel


class MedicalResponse(BaseModel):
    answer: str
    recommendations: list[str]
    caution: str


class RAGChainManager:
    def __init__(self, retriever):
        self.retriever = retriever
        self.llm = ChatOpenAI(
            model=settings.LLM_MODEL_NAME,
            base_url=settings.LLM_BASE_URL,
            api_key=SecretStr(settings.GROQ_API_KEY),
        )

        self.parser = JsonOutputParser(pydantic_object=MedicalResponse)

    def _format_docs(self, docs):
        return "\n\n".join(doc.page_content for doc in docs)

    def build_chain(self):
        logger.info("Building LCEL RAG chain...")
        return (
            {
                "context": self.retriever | self._format_docs,
                "question": RunnablePassthrough(),
                "format_instructions": lambda _: self.parser.get_format_instructions(),
            }
            | ChatPromptTemplate.from_template("""
                You are a medical assistant for informational purposes only.

                STRICT RULES:
                - Do NOT include reasoning, explanation, or hidden steps.
                - Do NOT include markdown or extra text.

                Context:
                {context}

                Question:
                {question}
                                               
                {format_instructions}
                """)
            | self.llm
            | self.parser
        )
