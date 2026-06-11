import logging
from typing import List
from langchain_core.documents import Document
from langchain_community.document_loaders import TextLoader, PyPDFLoader, Docx2txtLoader

logger = logging.getLogger(__name__)

class DocumentLoaderFactory:
    """Factory to load different document types."""
    
    @staticmethod
    def load(file_path: str) -> List[Document]:
        logger.info(f"Loading document: {file_path}")
        
        try:
            if file_path.endswith(".txt"):
                loader = TextLoader(file_path)
            elif file_path.endswith(".pdf"):
                loader = PyPDFLoader(file_path)
            elif file_path.endswith(".docx"):
                loader = Docx2txtLoader(file_path)
            else:
                raise ValueError(f"Unsupported file type: {file_path}")
            
            documents = loader.load()
            logger.info(f"Successfully loaded {len(documents)} pages/sections from {file_path}")
            return documents
            
        except Exception as e:
            logger.error(f"Error loading {file_path}: {e}")
            raise
