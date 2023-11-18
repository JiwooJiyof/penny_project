import json
from typing import List, Dict, Union
from items import Item

class ShoppingList:
    def __init__(self, name: str):
        self.name = name
        self.items = []

    def add_item(self, item: Item):
        self.items.append(item)

    def remove_item(self, item_name: str):
        self.items = [item for item in self.items if item.name != item_name]

    def edit_name(self, new_name: str):
        self.name = new_name

    def __repr__(self):
        return f"ShoppingList(name={self.name}, items={self.items})"