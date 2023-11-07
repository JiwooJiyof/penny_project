import json
from stores import Store
from items import Item
from typing import List, Dict, Union

class Search:
    def __init__(self, stores: List[Store]):
        self.stores = stores

    def find_items(self, item_name: str) -> List[Dict[str, Union[Item, Store]]]:
        found_items = []
        for store in self.stores:
            for item in store.items:
                if item.name.lower() == item_name.lower():
                    found_items.append({"item": item, "store": store})
        return found_items

    def sort_by_price(self, items: List[Dict[str, Union[Item, Store]]], reverse: bool = False) -> List[Dict[str, Union[Item, Store]]]:
        return sorted(items, key=lambda x: x["item"].price, reverse=reverse)

    def sort_by_location(self, items: List[Dict[str, Union[Item, Store]]], reverse: bool = False) -> List[Dict[str, Union[Item, Store]]]:
        return sorted(items, key=lambda x: x["store"].location, reverse=reverse)