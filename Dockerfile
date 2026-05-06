FROM python:3.11.15-trixie

WORKDIR /app
COPY app/requirements.txt .
RUN pip install -r requirements.txt
COPY app/ .

CMD ["python", "app.py"]
