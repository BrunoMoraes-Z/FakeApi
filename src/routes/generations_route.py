# import datetime
import random
from datetime import date, datetime, timedelta

from faker import Faker
from fastapi import APIRouter
from fastapi.requests import Request
from fastapi.responses import JSONResponse
from pyboleto.bank.bradesco import BoletoBradesco
from pyboleto.bank.itau import BoletoItau


class GenerationRoute():

    def __init__(self) -> None:
        self.router = APIRouter()
        self.fake = Faker(locale='pt_BR')
        self._bind()

    def get_router(self) -> APIRouter:
        return self.router

    def _bind(self):

        def _generate_cuit():
            prefix = [20, 24, 27, 30, 34][int(random.random() * 4.9)]
            number = str(int(random.random() * 89999999 + 10000000))
            cuit = str(prefix) + number
            suma = 0

            for i in range(len(cuit)):
                suma += int(cuit[len(cuit) - i - 1]) * (2 + (i % 6))
            verificador = 11 - (suma % 11)

            if verificador == 11:
                verificador = 0
            if verificador == 10:
                return _generate_cuit()
            return cuit + str(verificador)

        def _gen_person():

            male = random.choice([0, 1]) == 1

            cpf = self.fake.cpf().replace("-", "").replace(".", "")
            cc = self.fake.credit_card_full().split("\n")
            rg: str = self.fake.rg()
            dob = self.fake.date_of_birth(minimum_age=18).__str__().split('-')

            while 'X' in rg.__str__():
                rg = self.fake.rg()

            return {
                "first_name": self.fake.first_name_male() if male else self.fake.first_name_female(),
                "last_name": self.fake.last_name_male() if male else self.fake.last_name_female(),
                "gender": 'male' if male else 'female',
                "email": f"{cpf}@getnada.com",
                "date_of_birth": f'{dob[2]}/{dob[1]}/{dob[0]}',
                "documents": {
                    "cpf": cpf,
                    "rg": rg,
                    'cuit': _generate_cuit(),
                },
                "iban": self.fake.iban(),
                "credit_card": {
                    "type": cc[0].lower(),
                    'number': cc[2].split(' ')[0],
                    'cvv': cc[3].split(' ')[1],
                    'expires_in': cc[2].split(' ')[1]
                }
            }

        def _gen_boleto(tipo: str = 'bradesco'):
            tipo = tipo.lower().strip()

            if tipo == 'bradesco':
                d = BoletoBradesco()
            elif tipo == 'itau':
                d = BoletoItau()

            d.carteira = '06'  # Contrato firmado com o Banco Bradesco
            d.cedente = 'Empresa ACME LTDA'
            d.cedente_documento = "102.323.777-01"
            d.cedente_endereco = ("Rua Acme, 123 - Centro - Sao Paulo/SP - " +
                                  "CEP: 12345-678")
            d.agencia_cedente = '0278-0'
            d.conta_cedente = '43905-3'

            # dd = datetime.today() + timedelta(days=5)
            d.data_vencimento = (datetime.now() + timedelta(days=5)).date()
            d.data_documento = date(2010, 2, 12)
            d.data_processamento = date(2010, 2, 13)
            d.instrucoes = [
                "- Linha 1",
                "- Sr Caixa, cobrar multa de 2% após o vencimento",
                "- Receber até 10 dias após o vencimento",
                ]
            d.demonstrativo = [
                "- Serviço Teste R$ 5,00",
                "- Total R$ 5,00",
                ]
            d.valor_documento = round(random.uniform(50, 2500), 2)
            d.nosso_numero = "1112011668"
            d.numero_documento = "1112011668"
            d.sacado = [
                "Cliente Teste %d" % 1,
                "Rua Desconhecida, 00/0000 - Não Sei - Cidade - Cep. 00000-000",
                ""
                ]
            return d.linha_digitavel.replace('.', ' ').replace(' ', '')

        @self.router.get('/gen/person')
        async def gen_person(req: Request):
            return JSONResponse(_gen_person())

        @self.router.get('/gen/person/{amount}')
        async def gen_person_2(req: Request, amount: int):
            amount = amount if amount < 101 else 100
            return JSONResponse([_gen_person() for i in range(amount)])

        @self.router.get('/gen/cpf')
        async def gen_cpf(req: Request):
            return JSONResponse({'cpf': self.fake.cpf().replace("-", "").replace(".", "")})

        @self.router.get('/gen/cpf/{amount}')
        async def gen_cpf_2(req: Request, amount: int):
            amount = amount if amount < 101 else 100
            return JSONResponse([{'cpf': self.fake.cpf().replace("-", "").replace(".", "")} for i in range(amount)])

        @self.router.get('/gen/rg')
        async def gen_rg(req: Request):
            return JSONResponse({'rg': self.fake.rg()})

        @self.router.get('/gen/rg/{amount}')
        async def gen_rg_2(req: Request, amount: int):
            amount = amount if amount < 101 else 100
            return JSONResponse([{'rg': self.fake.rg()} for i in range(amount)])

        @self.router.get('/gen/cnpj')
        async def gen_cnpj(req: Request):
            return JSONResponse({'cnpj': self.fake.cnpj().replace("-", "").replace(".", "").replace("/", "")})

        @self.router.get('/gen/cnpj/{amount}')
        async def gen_cnpj_2(req: Request, amount: int):
            amount = amount if amount < 101 else 100
            return JSONResponse([{'cnpj': self.fake.cnpj().replace("-", "").replace(".", "").replace("/", "")} for i in range(amount)])

        @self.router.get('/gen/cuit')
        async def gen_cuit(req: Request):
            return JSONResponse({'cuit': _generate_cuit()})

        @self.router.get('/gen/cuit/{amount}')
        async def gen_cuit_2(req: Request, amount: int):
            amount = amount if amount < 101 else 100
            return JSONResponse([{'cuit': _generate_cuit()} for i in range(amount)])

        @self.router.get('/gen/boleto/{tipo}')
        async def gen_cuit(req: Request, tipo: str):
            return JSONResponse({'boleto': _gen_boleto(tipo)})

        @self.router.get('/gen/boleto/bradesco')
        async def gen_cuit(req: Request):
            return JSONResponse({'boleto': _gen_boleto()})

        @self.router.get('/gen/boleto/bradesco/{amount}')
        async def gen_cuit_2(req: Request, amount: int):
            amount = amount if amount < 51 else 50
            return JSONResponse([{'boleto': _gen_boleto()} for i in range(amount)])