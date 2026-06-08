# **Gen AI Patient's Health info Generator - RAG System**

------------------------------------------------------------

## - ***Documentation***

#### *Document Loader*

--------------------------------------------------------------------------------

### **E.G:**

```py
    def load_text_file(text: str):
        with tempfile.NamedTemporaryFile(delete=False, suffix=".txt") as temp_file:
            temp_file.write(text.encode())
            temp_file_path = temp_file.name

        try:
            loader = TextLoader(temp_file_path)
            documents = loader.load()

            print(f"Loaded {len(documents)} document(s)")
            print(f"Content Preview: {documents[0].page_content[:100]}...")
            print(f"Metadata: {documents[0].metadata}...")

            for doc in documents:
                print(doc.page_content)
                print(doc.metadata)

        finally:
            os.remove(temp_file_path)


    def load_pdf_file(file_path: str):
        loader = PyPDFLoader(file_path)
        documents = loader.load()

        print(f"Loaded {len(documents)} document(s)")
        for i, doc in enumerate(documents):
            print(f"Doc {i+1} Content Preview: {doc.page_content[:100]}...")
            print(f"Doc {i+1} Metadata: {doc.metadata}...")
```

#### Setup Vector Databse for Chunking

--------------------------------------------------------------------------------

### **E.G:**

```py
    import chromadb

    chroma_client = chromadb.Client()

    collection = chroma_client.get_or_create_collection("test")

    documents = [
        {"id": "Doc_01", "text": "Hello, World!"},
        {"id": "Doc_02", "text": "How are you today?"},
        {"id": "Doc_03", "text": "Goodbye, see you later!"},
    ]

    for doc in documents:
        collection.upsert(id=doc["id"], documents=[doc["text"]])

    # user input
    query = "Hello, World!"

    results = collection.query(query_texts=[query], n_results=3)
```

#### Similarity Search using the User Query

--------------------------------------------------------------------------------

### **E.G:**

```py
    def similarity_seearch():
        with tempfile.TemporaryDirectory() as tmpdir:
            vectorstore = Chroma.from_documents(
                documents=Sample_Docs,
                embedding=embeddings_model,
                persist_directory=tmpdir,
            )

            print(
                f"Vector Store Created {vectorstore._collection.count()} documents and metadataas"
            )

            query = "What is Langchain?"
            results = vectorstore.similarity_search_with_score(query, k=3)

            print(f"Top 3 Results for Query {query}")
            for i, (doc, score) in enumerate(results):
                print(
                    f"Results {i+1}: {doc.page_content} (Score: {score:.4f['source']}), Source: {doc.metadata}"
                )
```

#### Metadata Filtering

--------------------------------------------------------------------------------

### **E.G:**

```py
    def metadata_filtering():
        with tempfile.TemporaryDirectory() as tmpdir:
            vectorstore = Chroma.from_documents(
                documents=Sample_Docs,
                embedding=embeddings_model,
                persist_directory=tmpdir,
            )

            query = "What databases are available?"

            results = vectorstore.similarity_search(query, k=5)
            print(f"Results without metadata filtering for query {query}")
            for i, doc in enumerate(results):
                print(
                    f"Result {i+1}: {doc.page_content} (Source: {doc.metadata['source']})"
                )
```

### Overlap Importance for get the idea for Text Overlaping in Chunking Phase

--------------------------------------------------------------------------------

**E.G:**

```py
    def overlap_importance():
        text = ("automates feature engineering by allowing the architecture to discover optimal representations directly from raw, structured data."* 3)
        # without overlap
        splitter_without_overlaps = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=0)
        # with overlap
        splitter_with_overlap = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=20)

        chunks_without_overlap = splitter_without_overlaps.split_text(text)
        chunks_with_overlap = splitter_with_overlap.split_text(text)

        print("Without Overlap:")
        print(f"Chunk 1 End: ...{chunks_without_overlap[0][-20:]}")
        print(f"Chunk 2 Start: ...{chunks_without_overlap[1][:20]}...")

        print("With Overlap:")
        print(f"Chunk 1 End: ...{chunks_with_overlap[0][-20:]}")
        print(f"Chunk 2 Start: ...{chunks_with_overlap[1][:20]}...")
```

### Hybrid Retriever for the get Stored Documents and Texts

--------------------------------------------------------------------------------

**E.G:**

```py
    def hybrid_retriever(query, retrievers, weights, k=3, rrf_k=60):
        """Combine multiple retriever using weighted reciprocal Rank Fusion"""
        doc_scores = {}

        for retriever, weight in zip(retrievers, weights):
            results = retriever.invoke(query)
            for rank, doc in enumerate(results):
                key = doc.page_content
                rrf_score = weight * (1.0 / (rank + rrf_k))

                if key in doc_scores:
                    doc_scores[key] = (doc_scores[key][0] + rrf_score, doc)
                else:
                    doc_scores[key] = (rrf_score, doc)

        sorted_docs = sorted(doc_scores.values(), key=lambda x: x[0], reverse=True)
        return [doc for _, doc in sorted_docs[:k]]
```

--------------------------------------------------------------------------------

### Text Split for the RAG System

> Firstly define the sample text for the splitting process

```py
    SAMPLE_TEXT = """
    # Comprehensive Lecture Notes: Neural Networks, Deep Learning, and Machine Learning Fundamentals

    ## Foundational Paradigms: AI, Machine Learning, and Deep Learning

    The strategic evolution of Artificial Intelligence (AI) represents a paradigm shift from deterministic, rule-based systems to sophisticated representation learning. Historically, AI systems operated by "following instructions," which proved brittle when confronted with the high-dimensional manifolds and non-linear complexities of real-world data. Modern Machine Learning (ML) focuses on "learning from experience," wherein the performance of a learning objective is fundamentally constrained by the input distribution. This evolution reached its current zenith with Deep Learning (DL), which automates feature engineering by allowing the architecture to discover optimal representations directly from raw, structured data.

    ### The Hierarchical Framework

    To understand the landscape of modern computation, we must distinguish between these nested tiers:

        - Artificial Intelligence (AI): The overarching discipline dedicated to constructing algorithms that simulate human cognitive functions.

        - Machine Learning (ML): A subset of AI emphasizing computer algorithms that improve automatically through experience. It utilizes statistical models to identify patterns and perform inference without explicit hard-coded logic.

        - Deep Learning (DL): A specialized branch of ML utilizing artificial neural networks with multiple hidden layers.

    It is uniquely suited for processing data with complex, grid-like topologies (such as images or time-series data) and performing automated feature extraction.
    """
```

--------------------------------------------------------------------------------

#### Setup the text splitter or chunking process

> Using the Recursive Character Splitter for this Process

```py
    def recursive_splitter():
        splitter = RecursiveCharacterTextSplitter(
            chunk_size=500,
            chunk_ovelap=50,
            separators=["\n\n", "\n", " ", ""],
        )

        chunks = splitter, split_text(SAMPLE_TEXT)

        print(f"Original Length: {len(SAMPLE_TEXT)} chars")
        print(f"Number of Chunks: {len(chunks)}")
        print(f"Chunk Size: {[len(c) for c in chunks]}")
        print(f"\nFirst Chunk Preview: \n {chunks[0][:200]}...")
```

--------------------------------------------------------------------------------

### Embedding Deep

> Initalize the Embedding Model for the System

```py
embeddings = OpenAIEmbeddings(model="text-embedding-3-small")
```

> This function represent the multiple files in resources embeddings

```py
# only one text
def single_embedding():
    text = "What is Machine Learning?"
    single_embedding = embeddings.embed_query(text)

    print(f"Vector Dimension: {len(single_embedding)}")
    print(f"First 5 Values: {single_embedding[:5]}")
    print(f"Vector Norm: {np.linalg.norm(single_embedding):.4f}")
```

> This function represent the multiple files in resources embeddings

```py
# only multiple texts
def batch_embedding():
    text = [
        "What is Langchain?",
        "Who created LangChain?",
        "What is LangGraph used for?",
    ]

    embedding = embeddings.embed_document(text)
    for i, emb in enumerate(embedding):
        print(f"Text {i+1} - Vector Dimension: {len(emb)}")
        print(f"Text {i+1} - First 5 Value: {emb[:5]}")
        print(f"Text {i+1} - Vector Norm: {np.linalg.norm(emb):.4f}")
```

--------------------------------------------------------------------------------

### Similarity Search

> Find the most similar or equality searches for user input within the documents

```py
def similarity_search(docs: List = None, query: str = ""):
    doc_vector = embeddings.embed_documents(docs)
    query_vector = embeddings.embed_query(query)

    # compute cosine similarities
    def cosine_similarity(vec1, vec2):
        return np.dot(vec1, vec2) / (np.linalg.norm(vec1) * np.linalg.norm(vec2))

    similarities = [cosine_similarity(query_vector, doc_vec) for doc_vec in doc_vector]
    # rank documents by similarity
    ranked_docs = sorted(zip(docs, similarities), key=lambda x: x[1], reverse=True)

    print(f"Query: {query}\n")
    print(f"Ranked by Similarity:")
    for doc, score in ranked_docs:
        print(f"{score:.4f}: {doc}")
```

--------------------------------------------------------------------------------

## Cost Optimization For RAG System

#### - Token Budgeting

```py
class TokenBudgeting:
    def __ini__(self, max_tokens_per_request: int = 4000):
        self.max_tokens_per_request = max_tokens_per_request
        self.usage = {"total_input": 0, "total_output": 0, "request": 0}

    def estimate_tokens(self, text: str) -> int:
        """Rough Token Estimation(Actual would use TikToken)"""
        return int(len(text.split()) * 1.3)

    def check_bugs(self, text: str) -> tuple[bool, int]:
        """Check if Request is Within Budget"""
        tokens = self.estimate_tokens(text)
        return tokens <= self.max_tokens_per_request, tokens

    def record_usage(self, input_tokens: int, output_tokens: int):
        """Record Token Usage."""
        self.usage["total_input"] += input_tokens
        self.usage["total_output"] += output_tokens
        self.usage["request"] += 1

    def get_stats(self) -> Dict:
        return {
            **self.usage
        }

```

--------------------------------------------------------------------------------

## Basic RAG Pipeline for system

#### Import the Libraries for the System

```py
from anyio import mkdtemp
from langchain_openai.embeddings import OpenAIEmbeddings
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough, RunnableParallel
from lanchain_openai import ChatOpenAI, OpenAIEmbeddings
from langchain.chat_models import init_chat_model
from langchain_chroma import Chroma
from langchain_core.documents import Document
from langchain_text_splitters import RecursiveCharacterTextSplitter
from pydantic import BaseModel, Field
from typing import List
from dotenv import load_dotenv
import tempfile
```

--------------------------------------------------------------------------------

#### Build the Knowledge Base Function
>
> This Function build the vector strore and store the splitted characters or words in this storage in temperaly.

```py
load_dotenv()
embeddings_model = OpenAIEmbeddings(model='text-embedding-3-small')

def create_knowledge_base():
    """Create a vector store from knowledge base."""
    splitter= RecursiveCharacterTextSplitter(chunk_size = 500, chunk_overlap=50)
    doc = Document(
        page_content=KNOWLEDGE_BASE,
        metadata={'source': 'langchain_knowledge_base.md'},
        )
    chunks = splitter.split_documents([doc])

    vector_store = Chroma.from_documents(
        documents=chunks
        embedding=embeddings_model,
        persist_directory=tempfile.mkdtemp()
    )
    return vector_store
```

--------------------------------------------------------------------------------

#### Build the Basic RAG Pipeline
>
> This pipeline works sequential in ordered. Finally, Display the generated text to the user.

```py
def basic_rag():
    vector_store = create_knowledge_base()
    retriever = vector_store.as_retriever(search_type='similarity', search_kwargs={'k': 2},)
    # create the large language model
    llm = init_chat_model(model='gpt-4o-mini', temperature=0.2,)

    # build rag prompt template
    prompt = ChatPromptTemplate.from_template(
        """
            Answer the question based only on the following context:
            {context}

            Question: {question}

            Answer: {answer}

            Make sure to answer in a concise manner,
            and if you don't know the answer, just say "I Dont't Know."
        """
    )

    def format_docs(docs):
        return "\n\n".join([doc.page_content for doc in docs])
    
    rag_chain = ({"context": retriever | format_docs, "question": RunnablePassthrough()}
                 | prompt
                 | llm
                 | StrOutputParser()
                 )
    

    # test the rag chain
    question = [
        'What is Langchain?',
        'Who created LangChain?',
        'What is LangGraph used for?',
        ]
    
    print("Basic Rag Demo: \n")
    for q in question:
        answer = rag_chain.invoke(q)
        print(f"Q: {q}")
        print(f"A: {answer}\n")

```

--------------------------------------------------------------------------------
