from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello from app2 on port 5002"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002)