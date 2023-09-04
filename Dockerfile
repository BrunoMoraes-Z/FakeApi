# Imagem base
FROM python:3.10

ENV TZ "America/Sao_Paulo"
ENV TIMEZONE "America/Sao_Paulo"

WORKDIR /app

COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/

EXPOSE 8000

CMD ["uvicorn", "src.main:app", "--no-server-header", "--host", "0.0.0.0", "--port", "8000", "--workers", "6"]