from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
from res_models import get_response_json, StatusCode
from ocr.router import router as ocr_router

app = FastAPI(
    debug       = True,
    title       = "Medicare Plus API",
    version     = "1.0.0",
    description = "Personalized Patient Monitoring System"
)

# ✅ Fix: Allow dashboard.html to talk to this server
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(ocr_router)

@app.get("/", status_code=200, tags=["Root"])
def read_root():
    try:
        return get_response_json(
            status_code=StatusCode.OK,
            message="Welcome to the Medicare+ API!"
        )
    except Exception as e:
        return get_response_json(
            status_code=StatusCode.INTERNAL_SERVER_ERROR,
            message=f"An error occurred: {str(e)}",
        )

if __name__ == "__main__":
    uvicorn.run(app, port=8000)