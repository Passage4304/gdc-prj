FROM python:3.9-alpine

WORKDIR /app

RUN pip install --no-cache-dir flask

COPY . .

EXPOSE 5001

CMD ["python3", "app.py"]