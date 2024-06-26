from flask import Flask, request, jsonify
import random

app = Flask(__name__)

@app.route('/')
def home():
    return "Welcome to the Complex Python Microservice!"

@app.route('/api/random', methods=['GET'])
def get_random_number():
    return jsonify({'random_number': random.randint(1, 100)})

@app.route('/api/echo', methods=['POST'])
def echo():
    data = request.get_json()
    return jsonify(data)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
