from __future__ import annotations
import re
from common import Product
from bs4 import BeautifulSoup
from selenium import webdriver
from seleniumbase import Driver
from typing import *
from common import WebScraper
import time


class NoFrillsScraper(WebScraper):
    def get_all_products_from_html(self, html: str) -> List[Product]:
        soup = BeautifulSoup(html, 'html.parser')
        result = []
        product_tabs = soup.find_all("div", class_="chakra-linkbox css-wsykbb")
        for product in product_tabs:
            # print(product.prettify())
            title = product.find('h3', class_='chakra-heading').text.strip()
            # print(f"Product: {title}")

            # Extract price
            # price = product.find('p', class_='chakra-text css-1hj0zgu').text.strip()
            # print(f"Price: {price}")

            # Extract package size
            # print(f"Package Size: {package_size}")
            box = product.find('div', class_='css-0')
            package_size_text = box.find_all('p', class_='chakra-text')[-1].text.strip()

            # Extract price and unit
            # print(package_size_text, "package size text")
            try:
                # examples of what we need to proccess.
                # 3 lb bag, $0.22/100g
                # $3.28/1kg
                # 1.113 kg, $0.36/100g
                # print("trying to proccess")
                price, unit = re.findall(r"(\$\d+\.\d+\/\d+\w+)", package_size_text)[0].split('/')
                price = float(price.replace('$', '').strip())
                pattern = r'(\d+)([a-zA-Z]+)'

                match = re.match(pattern, unit)
                unit_size = float(match.group(1))
                unit_type = match.group(2)
                # print("unit size: ", unit_size, "unit: ", unit_type)
                if unit_type == "kg":
                    price = price / (1000 * unit_size)
                    unit_type = "g"
                elif unit_type == "g":
                    price = price / unit_size

                # print(f"Price: ${price}, Unitamount: {unit_type}")
                product = Product(title, price, unit_type)
                result.append(product)
                # print(product)
            except:
                pass

            # print("product\n")
        return result

    def page_number_name(self, url: str, num: int) -> str:
        if num == 1:
            return url
        return f"{url}?page={num}"


if __name__ == '__main__':
    scraper = NoFrillsScraper()
    url = "https://www.nofrills.ca/"
    scraper.hit_page_fast(url)
    url = "https://www.nofrills.ca/food/fruits-vegetables/c/28000?navid=flyout-L2-fruits-vegetables"
    scraper.hit_page_fast(url)
    url = "https://www.nofrills.ca/food/fruits-vegetables/fresh-vegetables/c/28195"
    for i in scraper.get_range(url, 6):
        print(i)

