# Penny Development

### Table of contents
1. [Project Architecture](#project-architecture)
2. [Key Features](#key-features)
3. [Development requirements](#development-requirements)
4. [Deployment and Github Workflow](#deployment-and-github-workflow)
5. [Coding Standards and Guidelines](#coding-standards-and-guidelines)
6. [Accessing the project](#accessing-the-project)
7. [Licenses](#licenses)

## Project Architecture
There are four main components that make up our application: the webscraper, database, backend, and frontend. 
- The webscraper is responsible for scraping the data from external websites such as No Frills and Metro and sending it to the database. 
- The database is responsible for storing all program related data. 
- The backend is responsible for sending the data from the database to the frontend as well as
any logic details, such as handling the google maps API as well as any authentication. The vast
majority of app logic is handled in the back end.
- The frontend is responsible for displaying the data to the user as well as handling all user interaction.

### scraper
The scraper is stored in "Penny/WebScraper" and is written in Python. The main class involved is the webscrape class. This class is responsible for connecting to the grocery store's websites and has many helper methods for parsing data. For now, there two classes that inherit from the webscrape, the Metro scraper and the No Frills scraper. These classes only have to implement two methods. Due to the nature of webscraping, the scraper is very fragile and can break easily.

### database
The database is stored in Supabase. Our partner was the one who introduced us to it and is proficient in using it. For app-related logic, we used capabilities built into Django.

### backend
The backend is stored in "Penny/python_backend/penny/penny" and is written in Python. It utilizes Django framework. It has five main folders: accounts, items, shopping cart, stores, and penny.
- **accounts**
The accounts folder is responsible for all user related logic. It contains logic for user creation, user authentication, and password validation.
- **items**
The items folder is responsible for all store item related logic. It contains logic for item sorting and searching, as well as price conversion.
- **shopping cart**
The shopping cart folder is responsible for all shopping cart related logic. It contains logic for adding and removing items from the shopping cart as well as persisting the shopping cart from session to session.
- **stores**
The stores folder handles all of the store location related queries. It contains logic for finding the nearest store.
- **penny**
This is responsible for running the server and connecting to the database.

### frontend
The frontend is stored in "Penny/lib" and is written in Dart. It utilizes the Flutter framework. There are two main folders: pages and widgets. Each folder contains the respective pages and widgets. The main pages are: home page, login page, sign up page, and select product page.

## Key Features
The key features in the applications are searching for grocery products, creating shopping lists, searching for stores/locations, price logging, user account system, and a cost-to-distance ratio.
Key Features:
- Searching for grocery products: users can enter or select the grocery items they are looking to purchase, where the app will display a list of stores with that product and its prices. Users can also sort and filter based off the pricing, which will be updated in real-time.
- Creating shopping lists: users can add items to their shopping list and can save, edit, or delete them. Users can also share their shopping list via email, messaging, or any other sharing option.
- Searching for stores/locations: users can input their location or turn on location services to detect the nearest grocery stores to them. From there, users can view the nearest grocery stores on the map and get directions, where each store will have basic information such as opening hours, contact information, and address.
- Price logging: if users see that a price on Penny does not match the current price at the store, users can update the price on the app for everyone else to see.
- User account system: users can register for an account and log in on the site. From here, they can access every feature needed, which would be searching for products and stores, creating shopping lists, and logging/changing prices of a product. Users also have the ability to view their profile, update any of the information, and logout.
- Cost-to-distance ratio: users can see a cost-to-distance ratio for each store considering their shopping list price(s) and the distance to the store. They can sort and filter the stores based on the ratio and also get directions with different modes of transportation.

## Development requirements

The technical requirements for a developer to set up on their machine or server is to have Python3.9 and Flutter.SDK and Flutter extension on VSCode installed and then install our repository from the source:

```
git clone https://github.com/csc301-2023-fall/project-26-penny-t.git
```

then use a virtual environment and install Django within the environment.

```
python3 -m venv venv

source venv/bin/activate

pip install django

# Django REST framework
pip install djangorestframework
pip install markdown       # Markdown support for the browsable API.
pip install django-filter  # Filtering support

# Json web token
pip install djangorestframework-simplejwt

# Origin
pip install django-cors-headers

pip install psycopg2-binary
```

Next, to run the application's backend and connect to the database, the developer must navigate to the python_backend folder and in their terminal run:

```
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver
```

Last, to run the application's frontend, the developer must run `main.dart` in the lib folder. Pick a device to use and it will launch Flutter where you can navigate through the website.

## Deployment and Github Workflow

Our team's GitHub workflow follows the common GitHub workflow. We started by hosting our repository on GitHub and each made a local clone of the repository individually. For each sub-team's part, we made branches to make and commit changes to work within our sub-team, then pushed any changes once they were finished. Next each sub-team would create a pull request onto the main branch where the team members within each sub-team would review them before merging, adding comments where needed. If there were needed changes, the member who created the pull request would fix them and send the code in fo review again. Then, once the review is complete, the sub-team would be responsible for merging them as a group.

We chose this workflow because it is what most of our team members are familiar with based on other courses and personal/professional experiences.

Overall deployment process from writing code to viewing a live application was to first populate the database in Supabase by webscraping, then sending the data over using API requests for the backend who will run the server on their terminal, and then frontend connects to the backend as well and deploys over Flutter.

Deployment tools we used were GitHub for backend, Supabase for database, and Flutter for frontend.

## Coding Standards and Guidelines

Our main coding standards and guidelines are surrounding naming conventions and proper indentation. Each member ensured the naming conventions for our variables and functions are using meaningful and understandable names that describe what they are used for and ensuring no digits were used during naming. For proper indentation, we made sure to use white spaces where needed for a visually appealing format, including spaces after commas and indentations for nested blocks.

## Accessing the project
We will give full access to our Github repository to our partner. Our partner is an experienced developer with lots of experience with all of these technologies.

## Licenses

The type of license we will apply to our codebase is the default copyright because our partner has not decided on the type of license he wants yet. This means that people who are not a part of the team should not be copying the development and use of our codebase due to copyright.
