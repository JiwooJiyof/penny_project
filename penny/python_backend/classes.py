import json
import getpass
from stores import Store
from items import Item
from typing import List, Dict, Union


class User:
    def __init__(self, name, username, password, location=None, email=None):
        self.name = name
        self.username = username
        self.password = password
        self.location = location
        self.email = email

    def __str__(self):
        return f"Name: {self.name}, Username: {self.username}, Location: {self.location}"

    def update_username(self, curr_user, json_filename):
        try:
            new_username = input("New Username: ")
            with open(json_filename, 'r') as json_file:
                data = json.load(json_file)

            users = data.get("users", [])
            for user in users:
                if user.get('username') == curr_user.username:
                    user['username'] = new_username

            with open(json_filename, 'w') as json_file:
                json.dump(data, json_file, indent=4)
            print("Username has been updated!\n")
            curr_user.username = new_username
            mainpage(curr_user)
            return "Username has been updated!"
        except Exception as e:
            return e
        

    def update_password(self, curr_user, json_filename):
        try:
            curr_password = getpass.getpass("Confirm Password: ")
            if curr_password == curr_user.password:
                new_password = getpass.getpass("New Password: ")
                with open(json_filename, 'r') as json_file:
                    data = json.load(json_file)

                users = data.get("users", [])
                for user in users:
                    if user.get('username') == curr_user.username:
                        user['password'] = new_password

                with open(json_filename, 'w') as json_file:
                    json.dump(data, json_file, indent=4)
                print("Password has been updated!\n")
                curr_user.password = new_password
                mainpage(curr_user)
                return "Password has been updated!\n"
            else:
                print("Wrong password\n")
                mainpage(curr_user)
                return "Wrong password\n"
        except Exception as e:
            return e

    def update_location(self, curr_user, json_filename):
        try:
            new_location = input("New Location: ")
            with open(json_filename, 'r') as json_file:
                data = json.load(json_file)

            users = data.get("users", [])
            for user in users:
                if user.get('username') == curr_user.username:
                    user['location'] = new_location

            with open(json_filename, 'w') as json_file:
                json.dump(data, json_file, indent=4)
            print("Location has been updated!\n")
            curr_user.location = new_location
            mainpage(curr_user)
            return "Location has been updated!\n"
        except Exception as e:
            return e


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


class Store:
    def __init__(self, store_info):
        self.name = store_info['store']
        self.location = store_info.get('location') 
        self.items = [Item(item) for item in store_info['items']]


class Item:
    def __init__(self, item_data):
        # Extract the name and price from the item_data dictionary
        self.name = list(item_data.keys())[0]
        self.price = item_data[self.name]


def valid_user(username_to_check, password_to_check, json_filename):
    with open(json_filename, 'r') as json_file:
        data = json.load(json_file)
        users = data['users']

        for user in users:
            if user['username'] == username_to_check and user.get('password') == password_to_check:
                return True

    return False


def create_user(new_user, json_filename):
    with open(json_filename, 'r') as json_file:
        data = json.load(json_file)

    new_user_dict = {
        "name": new_user.name,
        "username": new_user.username,
        "password": new_user.password,
        "location": new_user.location,
        "email": new_user.email
    }

    users = data.get("users", [])
    users.append(new_user_dict)

    with open(json_filename, 'w') as json_file:
        data["users"] = users
        json.dump(data, json_file, indent=4)


def initialize_search(json_filename):
    # Read data from the JSON file
    with open(json_filename, 'r') as json_file:
        data = json.load(json_file)

    # Assuming the JSON file has a key named 'stores' containing a list of store data
    store_data = data.get('stores', [])

    # Create a list of Store objects from the store data
    stores = [Store(store_info) for store_info in store_data]

    # Initialize the Search object with the list of stores
    search = Search(stores)

    return search


def init():
    command = input(
        "Welcome to the Penny!\nType 'Log In' to log in or 'Sign Up' if you don't have an account!\n")

    if command.lower() == "log in":
        login()
    elif command.lower() == "sign up":
        signup()

    else:
        print("Invalid Input")
        init()

    return 1


def signup():
    try:
        json_filename = "users.json"
        name = input("Write your full name: ")
        username = input("Create your username: ")
        with open(json_filename, 'r') as json_file:
            data = json.load(json_file)
            users = data['users']

            for user in users:
                if user['username'] == username:
                    print("Username already exists. Create a new username\n")
                    signup()

        password = getpass.getpass("Create your password: ")
        password_confirm = getpass.getpass("Confirm your password: ")
        while password != password_confirm:
            password_confirm = getpass.getpass(
                "Password different. Confirm your password: ")
        new_user = User(name, username, password)
        create_user(new_user, json_filename)
        print("Sign Up Complete!")
        init()
        return "Sign Up Complete!"
    except Exception as e:
        return e


def login():
    try:
        json_filename = "users.json"
        username_to_check = input("Enter your username: ")
        password_to_check = getpass.getpass("Enter your password: ")

        # Check valid user
        if valid_user(username_to_check, password_to_check, json_filename):
            # Get Name
            name = None
            location = None
            with open(json_filename, 'r') as json_file:
                data = json.load(json_file)

            users = data.get("users", [])

            for user in users:
                if user.get('username') == username_to_check:
                    name = user.get('name')

            # Get Location
            with open(json_filename, 'r') as json_file:
                data = json.load(json_file)

            users = data.get("users", [])

            for user in users:
                if user.get('username') == username_to_check:
                    location = user.get('location')

            # Create User
            curr_user = User(name, username_to_check, password_to_check, location)
            print("Welcome " + username_to_check)
            mainpage(curr_user)
            return "Welcome " + username_to_check
        else:
            print("Login failed. Please check your username and password.\n")
            init()
            return "Login failed. Please check your username and password.\n"
    except Exception as e:
        return e




def mainpage(curr_user):
    command = input(
        "Choose what to do:\n Type 'Log Out' to log out\n Type 'Profile' to see current profile\n Type 'Update' to update user profile\n Type 'Search' to search groceries\n")
    if command.lower() == "log out":
        init()
    elif command.lower() == "profile":
        print(curr_user)
        print()
        mainpage(curr_user)
    elif command.lower() == "update":
        update(curr_user)
    elif command.lower() == "search":
        grocery_page(curr_user)
    else:
        print("Invalid")
        mainpage(curr_user)


def update(curr_user):
    json_filename = "users.json"
    cmd = input(
        "Choose one of the following to update:\nUsername\nPassword\nLocation\n")
    if cmd.lower() == "username":
        curr_user.update_username(curr_user, json_filename)
    elif cmd.lower() == "password":
        curr_user.update_password(curr_user, json_filename)
    elif cmd.lower() == "location":
        curr_user.update_location(curr_user, json_filename)
    else:
        print("Invalid\n")
        mainpage(curr_user)


def grocery_page(curr_user):
    item = input("Search item: ")
    search = initialize_search("stores.json")

    # Call the find_items method and store the results
    found_items = search.find_items(item)
    if not found_items:
        print("No items available\n")
        grocery_page(curr_user)

    # Iterate over the found items and print their details
    for result in found_items:
        item = result['item']
        store = result['store']
        print(f"{item.name}: ${item.price} at {store.name}")

    cmd = input(
        "Choose what to do:\n Type 'Sort' to sort by price\n Type 'Search' to search another item\n Type 'Main' to return to the main page\n")

    if cmd.lower() == "search":
        grocery_page(curr_user)
    elif cmd.lower() == "sort":
        # sort items
        sorted_items = search.sort_by_price(found_items)

        for result in sorted_items:
            item = result['item']
            store = result['store']
            print(f"{item.name}: ${item.price} at {store.name}")
        grocery_page(curr_user)
    elif cmd.lower() == "main":
        mainpage(curr_user)
    else:
        print("Invalid\n")

    # return to main
    mainpage(curr_user)
