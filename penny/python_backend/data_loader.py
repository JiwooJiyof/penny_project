import json
from stores import Store
from items import Item
from typing import List, Dict, Union
def load_data_from_json(json_data: str) -> List[Store]:
    data = json.loads(json_data)
    stores = []
    for store_data in data:
        items = [Item(item["name"], item["price"]) for item in store_data["items"]]
        store = Store(store_data["store"], store_data["location"], items)
        stores.append(store)
    return stores