from __future__ import annotations
import time
from typing import *
from dataclasses import dataclass
from selenium import webdriver
from seleniumbase import Driver
from bs4 import BeautifulSoup, PageElement
from add_products import Product
from add_products import add_products


def handle_prices(price: float, unit_amount: float, unit_type: str) -> Tuple[float, str]:
    """handles the prices of the products. If the unit type is kg, it converts it to 100g. If the unit type is lb, it
    converts it to 100g. If the unit type is g, it converts it to 100g. If the unit type is 100g, it does nothing.
    """
    # if unit_type == "kg":
    #     price = price / (1000 * unit_amount)
    #     unit_type = "100g"
    # elif unit_type == "g":
    #     price = price * 100 / unit_amount
    #     unit_type = "100g"
    # elif unit_type == "lb":
    #     price = price / (unit_amount * 0.453592)
    #     unit_type = "100g"
    return price, unit_type
# @dataclass
# class Product:
#     name: str
#     price: float
#     unit_type: str
#     store_name: str
#     image_url: Optional[str] = None
#     # brand: Optional[str] = None


class WebScraper:
    def __init__(self):
        options = webdriver.ChromeOptions()
        options.add_argument("--headless")
        self.driver = Driver(uc=True, incognito=True)

    def hit_page_fast(self, url: str):
        """
        You need to traverse the website link by link in order not to trigger bot detection.
        use this function to do it fast without waiting for JavaScript to reload.
        """
        time.sleep(1)
        self.driver.get(url)
        time.sleep(1)

    def get_page(self, url: str) -> str:
        """
        use this function to get a page that you need the html content of. It waits a bit of time for the javascript
        to load the relavent pages.
        """
        time.sleep(1)
        self.driver.get(url)
        time.sleep(10)
        self.driver.implicitly_wait(5)
        html = self.driver.page_source
        return html

    def get_all_products_from_html(self, html: str) -> List[Product]:
        """
        gets all the products from the html of a page. The subclasses themselves must implement this function.
        Note for testing purposes it's actually easier to first store the page on disk and then pass it to this function
        to prevent constant access of the website (which is really slow)
        """
        raise NotImplementedError

    def get_all_products(self, url: str) -> List[Product]:
        """just a more convenient function to get all the products from a url. without having to turn it into html
        first"""
        html = self.get_page(url)
        return self.get_all_products_from_html(html)

    def page_number_name(self, url: str, num: int) -> str:
        """takes in the base url of a page and adds the page number to it. This is different for each website"""
        raise NotImplementedError

    def get_range(self, base_url: str, end: int, start: int = 1) -> List[Product]:
        """gets all the products from a range of pages"""
        result = []
        for i in range(start, end + 1):
            url = self.page_number_name(base_url, i)
            result.extend(self.get_all_products(url))
        return result


    def add_range_to_database(self, base_url: str, end: int, start: int = 1) -> List[Product]:
        """gets all the products from a range of pages and adds them to the database. Returns all items it added to
        the database"""
        result = self.get_range(base_url, end, start)
        print(result)
        add_products(result)
        return result
