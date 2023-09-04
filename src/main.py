from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware

from src.routes.api import router


def get_application() -> FastAPI:

    application = FastAPI(
        title='Fake API',
        version='1.0.0',
    )

    application.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    application.include_router(router)
    return application

app = get_application()