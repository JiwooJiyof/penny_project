import os
from typing import Optional, List

from dotenv import load_dotenv
from supabase import create_client, Client
from dataclasses import dataclass

load_dotenv()

url: str = os.getenv("SUPABASE_URL")
key: str = os.getenv("SUPABASE_KEY")
supabase: Client = create_client(url, key)


@dataclass
class Product:
    display_name: str
    unit_type: str
    store_name: str
    price: float
    image_url: Optional[str] = None




def find_product_id(pruduct_name: str, store: str) -> Optional[int]:
    pass
def add_products(products: List[Product]):

    for product in products:
        supabase.table('products').insert(
            {"display_name": product.name, "unit_system": product.unit_type}).execute()


def update_product(new_name, uuid):
    supabase.table('products').update({'display_name': new_name}).eq(
        'id', uuid).execute()  # uuid is automatically generated by database


if __name__ == '__main__':
    import uuid
    # prod1 = Product('apple', "g")
    # prod2 = Product('milk', "mL")
    # product_list = [prod1, prod2]
    # add_products(product_list)
    update_product('apples', uuid.UUID("e64192f2-9620-40e2-8043-fb4227663e51"))
