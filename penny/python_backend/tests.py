import json
import unittest
from unittest.mock import patch, mock_open
from classes import Search, create_user, valid_user, init, login, signup, Store 

class TestSearchClass(unittest.TestCase):

    def setUp(self):
        item1_data = {"apple": 0.5}
        item2_data = {"banana": 0.3}
        store_info1 = {'store': 'Store1', 'location': 'Location1', 'items': [item1_data]}  # Added location
        store_info2 = {'store': 'Store2', 'location': 'Location2', 'items': [item2_data]}  # Added location
        store1 = Store(store_info1)
        store2 = Store(store_info2)
        self.stores = [store1, store2]
        self.search = Search(self.stores)


    def test_find_items(self):
        results = self.search.find_items("apple")
        self.assertEqual(len(results), 1)
        self.assertEqual(results[0]['item'].name, 'apple')
        self.assertEqual(results[0]['store'].name, 'Store1')

    def test_sort_by_price(self):
        items = self.search.find_items("apple") + self.search.find_items("banana")
        sorted_items = self.search.sort_by_price(items)
        self.assertEqual(sorted_items[0]['item'].name, 'banana')
        self.assertEqual(sorted_items[1]['item'].name, 'apple')

    def test_sort_by_location(self):
        # Since the location is not defined in the store, this will sort alphabetically by store name.
        items = self.search.find_items("apple") + self.search.find_items("banana")
        sorted_items = self.search.sort_by_location(items)
        self.assertEqual(sorted_items[0]['store'].name, 'Store1')
        self.assertEqual(sorted_items[1]['store'].name, 'Store2')


class TestInitFunction(unittest.TestCase):

    @patch("builtins.input", side_effect=["log in"])
    def test_init_log_in(self, mock_input):
        with patch('classes.login') as mock_login:
            init()
            mock_login.assert_called_once()

    @patch("builtins.input", side_effect=["sign up"])
    def test_init_sign_up(self, mock_input):
        with patch('classes.signup') as mock_signup:
            init()
            mock_signup.assert_called_once()

class TestLoginFunction(unittest.TestCase):

    @patch("builtins.input", side_effect=["username"])
    @patch("getpass.getpass", side_effect=["wrongpassword"])
    @patch("classes.init", return_value="init called")
    def test_login_failed(self, mock_init, mock_getpass, mock_input):
        with unittest.mock.patch('builtins.open', unittest.mock.mock_open(read_data=json.dumps({"users": [{"username": "username", "password": "password", "name": "Test User"}]}))) as m:
            response = login()
            self.assertEqual(response, "Login failed. Please check your username and password.\n")


class TestSignupFunction(unittest.TestCase):

    @patch("builtins.input", side_effect=["Test User", "newuser"])
    @patch("getpass.getpass", side_effect=["password", "password"])
    @patch("classes.init", return_value="init called")
    def test_signup(self, mock_init, mock_getpass, mock_input):
        with unittest.mock.patch('builtins.open', unittest.mock.mock_open(read_data=json.dumps({"users": []}))) as m:
            response = signup()
            self.assertEqual(response, "Sign Up Complete!")



if __name__ == "__main__":
    unittest.main()
