from fastapi import APIRouter
from fastapi.responses import JSONResponse
from validate_docbr import CNH, CNPJ, CNS, CPF, PIS, RENAVAM


class ValidationsRoute():

    def __init__(self) -> None:
        self.router = APIRouter()
        self._bind()

    def get_router(self) -> APIRouter:
        return self.router

    def _bind(self):
        @self.router.get('/validate/cpf/{param}')
        async def validate_cpf(param):
            cpf = CPF()

            return JSONResponse(
                {'status': cpf.validate(param)},
                status_code= 200 if cpf.validate(param) else 400,
            )

        @self.router.get('/validate/cnpj/{param}')
        async def validate_cnpj(param):
            cnpj = CNPJ()

            return JSONResponse(
                {'status': cnpj.validate(param)},
                status_code= 200 if cnpj.validate(param) else 400,
            )

        @self.router.get('/validate/pis/{param}')
        async def validate_pis(param):
            pis = PIS()

            return JSONResponse(
                {'status': pis.validate(param)},
                status_code= 200 if pis.validate(param) else 400,
            )

        @self.router.get('/validate/renavam/{param}')
        async def validate_renavam(param):
            renavam = RENAVAM()

            return JSONResponse(
                {'status': renavam.validate(param)},
                status_code= 200 if renavam.validate(param) else 400,
            )

        @self.router.get('/validate/cnh/{param}')
        async def validate_cnh(param):
            cnh = CNH()

            return JSONResponse(
                {'status': cnh.validate(param)},
                status_code= 200 if cnh.validate(param) else 400,
            )

        @self.router.get('/validate/cns/{param}')
        async def validate_cns(param):
            cns = CNS()

            return JSONResponse(
                {'status': cns.validate(param)},
                status_code= 200 if cns.validate(param) else 400,
            )

        @self.router.get('/validate/cuit/{param}')
        async def validate_cuit(param):
            cuit = param

            if len(cuit) != 13 and len(cuit) != 11:
                return JSONResponse({'status': False}, status_code=400)

            base = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2]

            cuit = cuit.replace("-", "") # remuevo las barras

            # calculo el digito verificador:
            aux = 0
            for i in range(10):
                aux += int(cuit[i]) * base[i]

            aux = 11 - (aux - (int(aux / 11) * 11))

            if aux == 11:
                aux = 0
            if aux == 10:
                aux = 9

            # return aux == int(cuit[10])
            return JSONResponse(
                {'status': aux == int(cuit[10])},
                status_code= 200 if aux == int(cuit[10]) else 400,
            )