from typing import List

import requests
from bs4 import BeautifulSoup, PageElement
import json
import re
from selenium import webdriver
from seleniumbase import Driver
import time
from common import Product, WebScraper


class MetroScraper(WebScraper):
    def get_all_products_from_html(self, html: str) -> List[Product]:
        soup = BeautifulSoup(html, 'html.parser')
        product_tabs = soup.find_all("div", class_="default-product-tile")
        result = []
        for product in product_tabs:
            name = product.find('div', class_='head__title').text.strip()
            # print(f"Product: {name}")
            pricing_div = pricing_div = product.find("div", class_="content__pricing")
            unit_prices = pricing_div.find('div', class_='pricing__secondary-price').find_all('span')
            price = None
            unit_type = None
            for unit_price in unit_prices:
                unit_price = unit_price.get_text(strip=True)
                try:
                    price, unit = unit_price.split('/')
                    price = float(price.replace('$', '').strip())
                    pattern = r'(\d*)([a-zA-Z]+)'
                    match = re.match(pattern, unit)
                    unit_size = match.group(1)
                    if unit_size == "":
                        unit_size = 1
                    else:
                        unit_size = float(unit_size)
                    unit_type = match.group(2)
                    break
                except:
                    pass
            if unit_type == "kg":
                price = price / (1000 * unit_size)
                unit_type = "100g"
            elif unit_type == "g":
                price = price * 100 / unit_size
                unit_type = "100g"

            product = Product(name, price, unit_type)
            result.append(product)
            # print(f"Price: ${price}, Unitamount: {unit_type}, Unit Size: {unit_size}")
        return result

    def page_number_name(self, url: str, num: int) -> str:
        if num == 1:
            return url
        return f"{url}-page-{num}"











if __name__ == '__main__':
    scrapper = MetroScraper()
    # url = f"https://www.metro.ca/en/online-grocery/aisles/fruits-vegetables"
    url = "https://www.metro.ca/en"
    scrapper.hit_page_fast(url)
    url = f"https://www.metro.ca/en/online-grocery/aisles/fruits-vegetables"
    for i in scrapper.get_range(url, 4):
        print(i)






