import json
from typing import List, Dict, Union
from items import Item

class Store:
    def __init__(self, name: str, location: str, items: List[Item]):
        self.name = name
        self.location = location
        self.items = items

    def __repr__(self):
        return f"Store(name={self.name}, location={self.location}, items={self.items})"