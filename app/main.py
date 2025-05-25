"""Main module for the Flask application."""

from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello():
    """Return a friendly greeting."""
    return "Hello, World!"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
