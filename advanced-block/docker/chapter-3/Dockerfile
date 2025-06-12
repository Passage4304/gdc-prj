FROM python:3.9-alpine

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt

EXPOSE 5001

CMD ["python3", "app.py"]