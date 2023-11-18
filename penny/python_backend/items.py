import json
from typing import List, Dict, Union


class Item:
    def __init__(self, name: str, price: float):
        self.name = name
        self.price = price

    def __repr__(self):
        return f"Item(name={self.name}, price={self.price})"