import logging
from fastapi import FastAPI
from pydantic import BaseModel
from constants import Settings
from loader import DocumentLoaderFactory
from embeddor import DocumentEmbeddor
from chunker import DocumentChunker
from storage import VectorStoreManager
from retrieval import HybridRetriever
from generation import RAGChainManager

settings = Settings()

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)


def setup_rag_system(file_path: str):
    logger.info(f"Initializing Enterprise RAG System for {file_path}")
    documents = DocumentLoaderFactory.load(file_path)

    embeddor = DocumentEmbeddor().init_embeddor()

    chunker = DocumentChunker(
        is_semantic=False,
        chunk_size=settings.CHUNK_SIZE,
        chunk_overlap=settings.CHUNK_OVERLAP,
    )
    chunks = chunker.chunk(documents, embeddor)

    db_manager = VectorStoreManager()
    vector_store = db_manager.manager(chunks)

    retriever = HybridRetriever.from_documents(
        vector_store=vector_store, documents=chunks, k=settings.RETRIEVER_K
    )

    chain_manager = RAGChainManager(retriever=retriever)
    rag_chain = chain_manager.build_chain()

    return rag_chain


app = FastAPI()
rag_chain = setup_rag_system(
    "C:/Users/lahir/Desktop/Projects/Medicare-Plus-Project/server/ml/rag_gen_info/data/sample_medical_rag.pdf"
)


class QuestionRequest(BaseModel):
    question: str


@app.post("/ask")
def ask_question(req: QuestionRequest):
    response = rag_chain.invoke(req.question)
    return {"answer": response}
