# coding: utf-8

from flask import Flask, jsonify, url_for, render_template, send_from_directory
from redis import Redis
import os

from models import Item
from managers import RedisManager

app = Flask(__name__)
redis_manager = RedisManager()

@app.route("/")
def hello():
    data_dict = {"name": "watch"}
    return jsonify(data_dict)

@app.route("/item/<major>/<minor>", methods=["GET"])
def item(major, minor):
    data_dict = redis_manager.get_dict(major, minor)
    return jsonify(data_dict)

@app.route("/image/<name>")
def image(name):
    filename="images/{}".format(name)
    return send_from_directory("static", filename)

@app.route("/image_test")
def image_test():
    data_dict = {"image_url": url_for("static", filename="images/1.png")}
    return render_template("image.html", **data_dict)

def init_test_data():
    # add item1
    item1 = Item("mario", 1000, "a happy mario toy", "1.png", 12, 1, 10)
    dict1 = item1.to_dict()
    redis_manager.set_dict(dict1, 12, 1)

    # add item2
    item2 = Item("doraamon", 1500, "a cute doraamon", "2.png", 12, 2, 15)
    dict2 = item2.to_dict()
    redis_manager.set_dict(dict2, 12, 2)    

if __name__ == "__main__":
    init_test_data()
    app.run(host="0.0.0.0", debug=True)
