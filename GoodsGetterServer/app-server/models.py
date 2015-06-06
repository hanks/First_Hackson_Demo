# coding: utf-8

class Item(object):
    def __init__(self, name, price, description, image_url, major, minor, priority):
        self.name = name
        self.price = price
        self.description = description
        self.image_url = image_url
        self.minor = minor
        self.major = major
        self.priority = priority

    def to_dict(self):
        return {
            "name": self.name,
            "price": self.price,
            "description": self.description,
            "image_url": self.image_url,
            "minor": self.minor,
            "major": self.major,
            "priority": self.priority,
        }

    @classmethod
    def from_dict(cls, json_data):
        name = json_data["name"]
        price = int(json_data["price"])
        description = json_data["description"]
        image_url = json_data["image_url"]
        minor = int(json_data["minor"])
        major = int(json_data["major"])
        priority = int(json_data["priority"])

        return cls(name, price, description, image_url, major, minor, priority)

