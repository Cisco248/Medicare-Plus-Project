# import os
# import uuid
# from datetime import date
# from typing import List, Optional

# from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile
# from fastapi.responses import FileResponse
# from sqlalchemy.orm import Session

# from core import DocumentString, get_db
# from data import DocumentModel, DocumentStatusUpdate, DocumentUpdate
# from repository.middlewares.auth_middleware import AuthenticationMiddleware
# from repository.middlewares.document_middleware import DocumentMiddleware
# from repository.models.document_response import DocumentResponse

# document_router = APIRouter()


# def _get_owned_document(document_id: str, user_id: str, db: Session) -> DocumentModel:
#     document = (
#         db.query(DocumentModel)
#         .filter(DocumentModel.id == document_id, DocumentModel.user_id == user_id)
#         .first()
#     )
#     if not document:
#         raise HTTPException(404, DocumentString.NOT_FOUND.value)
#     return document


# @document_router.post(
#     "/documents",
#     status_code=201,
#     response_model=DocumentResponse,
#     tags=["Documents"],
# )
# async def upload_document(
#     title: str = Form(...),
#     doc_type: str = Form(...),
#     description: Optional[str] = Form(None),
#     issuer: Optional[str] = Form(None),
#     hospital: Optional[str] = Form(None),
#     report_date: Optional[date] = Form(None),
#     file: UploadFile = File(...),
#     db: Session = Depends(get_db),
#     auth: dict = Depends(AuthenticationMiddleware.auth_middleware),
# ):
#     if not title.strip() or not doc_type.strip():
#         raise HTTPException(400, DocumentString.FIELD_EMPTY.value)

#     extension = DocumentMiddleware.validate_extension(file)
#     file_path = await DocumentMiddleware.save_file(file, extension)

#     document = DocumentModel(
#         id=str(uuid.uuid4()),
#         user_id=auth["uid"],
#         title=title.strip(),
#         doc_type=doc_type.strip(),
#         file_name=file.filename,
#         file_path=file_path,
#         file_type=extension,
#         description=description,
#         issuer=issuer.strip() if issuer else None,
#         hospital=hospital.strip() if hospital else None,
#         report_date=report_date,
#         status="uploaded",
#     )
#     db.add(document)
#     db.commit()
#     db.refresh(document)
#     return document


# @document_router.get(
#     "/documents",
#     status_code=200,
#     response_model=List[DocumentResponse],
#     tags=["Documents"],
# )
# def get_documents(
#     db: Session = Depends(get_db),
#     auth: dict = Depends(AuthenticationMiddleware.auth_middleware),
# ):
#     return (
#         db.query(DocumentModel)
#         .filter(DocumentModel.user_id == auth["uid"])
#         .order_by(DocumentModel.created_at.desc())
#         .all()
#     )


# @document_router.get(
#     "/documents/{document_id}",
#     status_code=200,
#     response_model=DocumentResponse,
#     tags=["Documents"],
# )
# def get_document(
#     document_id: str,
#     db: Session = Depends(get_db),
#     auth: dict = Depends(AuthenticationMiddleware.auth_middleware),
# ):
#     return _get_owned_document(document_id, auth["uid"], db)


# @document_router.get(
#     "/documents/{document_id}/file",
#     status_code=200,
#     tags=["Documents"],
# )
# def download_document_file(
#     document_id: str,
#     db: Session = Depends(get_db),
#     auth: dict = Depends(AuthenticationMiddleware.auth_middleware),
# ):
#     document = _get_owned_document(document_id, auth["uid"], db)
#     if not os.path.exists(document.file_path):
#         raise HTTPException(404, DocumentString.FILE_MISSING.value)
#     return FileResponse(
#         document.file_path,
#         filename=document.file_name,
#         media_type=DocumentMiddleware.media_type(document.file_type),
#     )


# @document_router.put(
#     "/documents/{document_id}",
#     status_code=200,
#     response_model=DocumentResponse,
#     tags=["Documents"],
# )
# def update_document(
#     document_id: str,
#     model: DocumentUpdate,
#     db: Session = Depends(get_db),
#     auth: dict = Depends(AuthenticationMiddleware.auth_middleware),
# ):
#     document = _get_owned_document(document_id, auth["uid"], db)
#     if model.title is not None:
#         if not model.title.strip():
#             raise HTTPException(400, DocumentString.FIELD_EMPTY.value)
#         document.title = model.title.strip()
#     if model.doc_type is not None:
#         if not model.doc_type.strip():
#             raise HTTPException(400, DocumentString.FIELD_EMPTY.value)
#         document.doc_type = model.doc_type.strip()
#     if model.description is not None:
#         document.description = model.description
#     if model.issuer is not None:
#         document.issuer = model.issuer.strip() or None
#     if model.hospital is not None:
#         document.hospital = model.hospital.strip() or None
#     if model.report_date is not None:
#         document.report_date = model.report_date
#     db.commit()
#     db.refresh(document)
#     return document


# @document_router.patch(
#     "/documents/{document_id}/status",
#     status_code=200,
#     response_model=DocumentResponse,
#     tags=["Documents"],
# )
# def update_document_status(
#     document_id: str,
#     model: DocumentStatusUpdate,
#     db: Session = Depends(get_db),
#     auth: dict = Depends(AuthenticationMiddleware.auth_middleware),
# ):
#     document = _get_owned_document(document_id, auth["uid"], db)
#     document.status = DocumentMiddleware.validate_status(model.status)
#     db.commit()
#     db.refresh(document)
#     return document


# @document_router.delete(
#     "/documents/{document_id}",
#     status_code=200,
#     tags=["Documents"],
# )
# def delete_document(
#     document_id: str,
#     db: Session = Depends(get_db),
#     auth: dict = Depends(AuthenticationMiddleware.auth_middleware),
# ):
#     document = _get_owned_document(document_id, auth["uid"], db)
#     DocumentMiddleware.delete_file(document.file_path)
#     db.delete(document)
#     db.commit()
#     return {"message": "Document deleted successfully"}
