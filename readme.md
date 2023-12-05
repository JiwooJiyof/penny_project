# Penny/Boolean Boos

> _Note:_ This document is intended to be relatively short. Be concise and precise. Assume the reader has no prior knowledge of your application and is non-technical.
> ​

## Partner Intro

-   Kevin Lee, kevin@livekeen.com, Founder and Product Designer, primary point of contact for partner organization (Penny)
-   Penny is an early-stage startup organization founded by Kevin Lee in Toronto. The organization wishes to help consumers combat the challenging food prices in today's economy, with the consumer in mind, and build community around that aspect.

## Description about the project

-   Our application Penny will enable consumers to save on their groceries by taking unit pricing and comparing prices across multiple locations and stores. From an end-user's perspective, its value is that they are able to view products they wish to purchase and compare them in a variety of different stores for the best pricing. Users will be able to manage their grocery list and also section their list by stores, allowing them to pick and choose the best price for each list.
-   The problem we are trying to solve is the increasing food prices in the current economy downturn. They are a challenge for the normal consumer to face, but research shows that an average customer can save around 17% off their groceries with leveraged unit pricing. With Penny, customers can see the unit pricing for each product they wish to purchase and save as much as they can!
    ​

## Key Features

-   The key features in the applications are searching for grocery products, creating shopping lists, searching for stores/locations, price logging, user account system, and a cost-to-distance ratio.
-   Key Features:

            -   Searching for grocery products: users can enter or select the grocery items they are looking to purchase where the app will display a list of stores with that product and its prices. Users can also sort and filter based off the pricing, which will be updated in real-time.
            Value: 5/5

            - Creating shopping lists: users can add items to their shopping list and can save, edit, or delete them. Users can also share their shopping list via email, messaging, or any other sharing option.
            Value: 5/5

            - Searching for stores/locations: users can input their location or turn on location services to detect the nearest grocery stores to them. From there, users can view the nearest grocery stores on the map and get directions, where each store will have basic information such as opening hours, contact information, and address.
            Value: 5/5

            - Price logging: if users see that a price on Penny does not match the current price at the store, users can update the price on the app for everyone else to see.
            Value: 4/5

            - User account system: users can register for an account and log in on the site. From here, they can access every feature needed, which would be searching for products and stores, creating shopping lists, and logging/changing prices of a product. Users also have the ability to view their profile, update any of the information, and logout.
            Value: 5/5

            - Cost-to-distance ratio: users can see a cost-to-distance ratio for each store considering their shopping list price(s) and the distance to the store. They can sort and filter the stores based on the ratio and also get directions with different modes of transportation.
            Value: 3/5

## Instructions

-   To use the application from the end-user's perspective, the user will go to the website (https://app.shopwithpenny.com/) and register for an account with Penny. Then, this will register the user into our database and be logged in to access to all of Penny's features:

    -   Searching for grocery products: upon entering Penny, users will find themselves on Penny's homepage which displays a search bar and a grid view of many available products and their information. This means there are two ways to search for their products. If they want to search for a specific item, they can do so by entering their item into the search bar. This will show results from multiple grocery stores that have the item available. It may also result in other products showing up that include the item's name in the grid view (ex/ user searching for apple and apple chips show up). The other way is that the user scrolls through the homepage's gridview of products, where they can find the product they are interested in.

    -   Creating shopping lists: on Penny's homepage, the user will find a button at the top right of a shopping cart icon where they can create their shopping list. Here, they can input products into their list and check them off based on their needs. Once they are done with the product, they can erase it from their list.

    -   Searching for stores/locations: when registering, the user will be able to put in their address by inputting it or turning on location services. This will detect nearby grocery stores and allows products during search to be found at the nearest grocery store.

    -   Price logging: on Penny's homepage, the user can see a button on the bottom right of the homepage which says "Log Price." Once they click that button, they can choose the grocery store and the location they are at and then search for the product which has different information (ex. pricing) in-person versus on Penny. They can input the changed details and submit the change.

    -   User account system: upon opening the website, users are prompted to log in or register. If they are a new user, they will register, inputting all their information into the fillable form. Once they register, they are logged into their account and start at Penny's homepage. If they are a returning user, they will input their email and password and if those match, they are logged in starting at the Penny homepage.

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

Last, to run the application's frontend, the developer must run main.dart in the lib folder. Pick a device to use and it will launch Flutter where you can navigate through the website.

## Deployment and Github Workflow

-   Our team's GitHub workflow follows the common GitHub workflow. We started by hosting our repository on GitHub and each made a local clone of the repository individually. For each sub-team's part, we made branches to make and commit changes to work within our sub-team, then pushed any changes once they were finished. Next each sub-team would create a pull request onto the main branch where the team members within each sub-team would review them before merging, adding comments where needed. If there were needed changes, the member who created the pull request would fix them and send the code in fo review again. Then, once the review is complete, the sub-team would be responsible for merging them as a group.
-   We chose this workflow because it is what most of our team members are familiar with based on other courses and personal/professional experiences.
-   Overall deployment process from writing code to viewing a live application was to first populate the database in Supabase by webscraping, then sending the data over using API requests for the backend who will run the server on their terminal, and then frontend connects to the backend as well and deploys over Flutter.
-   Deployment tools we used were Render for backend, Supabase for database, and Flutter for frontend.

## Coding Standards and Guidelines

-   Our main coding standards and guidelines are surrounding naming conventions and proper indentation. Each member ensured the naming conventions for our variables and functions are using meaningful and understandable names that describe what they are used for and ensuring no digits were used during naming. For proper indentation, we made sure to use white spaces where needed for a visually appealing format, including spaces after commas and indentations for nested blocks.
    ​

## Licenses

-   The type of license we will apply to our codebase is the default copyright because our partner has not decided on the type of license he wants yet.
-   This means that people who are not a part of the team should not be copying the development and use of our codebase due to copyright.

