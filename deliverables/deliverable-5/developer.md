# Architecture

There are four main components that make up our application. 
The webscraper, the database, the backend, and the frontend. 
The webscraper is responsible for scraping the data from external websites such as 
no frills and metro and sending it to the database. 
The database is responsible for storing all program related data. 
The backend is responsible for sending the data from the database to the frontend as well as
any logic details. Such as handling the google maps API. as well as any authentication. The vast
majority of app logic is handled in the back end.
The frontend is responsible for displaying the data to the user
as well as handling all user interaction.

### scraper
The scraper is stored in "Penny/WebScraper" and is written in python. The main class involved
is the webscrape class. This class is responsible for connecting to the websites and has many
helper methods for parsing data. For now their are two classes that inherit from the webscrape
namely the metro scraper as well as the no frills scraper. These classes only have to implement
two methods.

Due to the nature of webscraping, the scraper is very fragile and can break easily.

### database
The database is stored in supabase. Our partner was the one who introduced us to it and is pretty proficient in using
it. For app related logic we used capabilities build into django.

### backend
The backend is stored in "Penny/python_backend/penny/penny" and is written in python. 
It utilizes the django framework. It has five main folders. Accounts, items, shopping cart, stores, and penny.

#### accounts
The accounts folder is responsible for all user related logic. It contains logic for user creation, user authentication, 
and password validation.

#### items
The items folder is responsible for all store item related logic. It contains logic for item sorting and searching
as well as price conversion.

#### shopping cart
The shopping cart folder is responsible for all shopping cart related logic. It contains logic for adding and removing
items from the shopping cart as well as persisting the shopping cart from session to session.

#### stores
The stores folder handles all of the store location related queries. It contains logic for finding the nearest store.

#### penny
This is responsible for running the server and connecting to the database.

### frontend
The frontend is stored in "Penny/lib" and is written in dart. It utilizes the flutter framework. 


