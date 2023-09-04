from fastapi import APIRouter

from src.routes.generations_route import GenerationRoute
from src.routes.validations_route import ValidationsRoute

router = APIRouter()

router.include_router(
    GenerationRoute().get_router(),
    tags=['Generations']
)

router.include_router(
    ValidationsRoute().get_router(),
    tags=['Validations']
)
