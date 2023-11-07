import json
import getpass


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

    def update_password(self, curr_user, json_filename):
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
        else:
            print("Wrong password\n")
            mainpage(curr_user)

    def update_location(self, curr_user, json_filename):
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


def login():
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
    else:
        print("Login failed. Please check your username and password.\n")
        init()


def mainpage(curr_user):
    command = input(
        "Choose what to do:\n Type 'Log Out' to log out\n Type 'Profile' to see current profile\n Type 'Update' to update user profile\n Type 'Groceries' to see groceries\n")
    if command.lower() == "log out":
        init()
    elif command.lower() == "profile":
        print(curr_user)
        print()
        mainpage(curr_user)
    elif command.lower() == "update":
        update(curr_user)
    elif command.lower() == "groceries":
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
    print("Currently Unavailable\n")
    mainpage(curr_user)
