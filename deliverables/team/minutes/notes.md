# Partner Meeting Minutes

## Meeting #1 (09/21/23)
Our first meeting with Kevin, where we had a round of introductions and an explanation of the scope of the project.

We discussed two routes we could go for the project, web scraping and gamification:
1. Web scraping
    1. There is rate limiting to keep in mind
        1. Documentation/JSON file for people who don’t contribute on daily basis for them to access for maintaining and updating it
- Metro is best place to do a dev spike on web scraping, they explicitly state that their prices match the stores, actual data
- Metro refreshes their prices every Thursday (either morning or night but shouldn’t really matter)
- In case of any major updates, working with IDs
- Use Puppeteer (Node.js) and Beautiful Soup (Python based classic web scraper)
- Both rely on a library w/ a number of commands – based off of IDs on a website
    - Puppeteer is a bit of a heavier load but loads javascript
        - Beautiful Soup just pulls the Dom and you can look at the dom/ids and pull value based on that
        - ChatGPT and GitHub copilot can web scrape
2. Community aspect - gamification: using google maps/swarm like tools (the idea of everyone reviewing stuff and people who contribute the most are most visible and to find those people and build it off them)
    1. Based in Dart/Flutter
        1. Similar to Swift UI, not similar to Python/Node.js/Rails

- Current Website for Application: http://app.shopwithpenny.com
- Choose gamification if web scraping is too time consuming/too big of a task
- Meeting twice a week until we don’t need to anymore – then once a week


## Meeting #2 (09/26/23)
Our second meeting with Kevin, where we made our decision on the route to go and asked questions regarding his app so far and expectations.

- Chose webscraping
    - Start off w/scraping 3 grocery stores
- Kevin’s priority: enabling someone who’s not a developer to continue to provide value without either any major or developer intervention 
    – He’s indifferent on how many groceries we web scrape from
- Identify where throttling mechanism might occur and work around it when web scraping using ChatGPT
- Uses Supabase for his databases
    - Created a "generic name" category for each product to compare them from each different store
- Talked about users and accounts
    - Top contributers are users who have the most "points" in helping the app update its information regarding products and stores
    - Looking for enthusiasts 
    - Weekly or biweekly leaderboard
    - Friends and communities on the app
- Eventually wants prediction data
    - Similar to Copper or Google Flights (wait a certain period and you save more money)
    - In-season products and lower prices

## Meeting #3 (10/03/23)
- Showing Kevin the Figma mockup of the webpage
    - Sitemaps: write why a person is here (what they have to do on specific webpages) to frame thinking
    - Kevin has been testing with beta testers, “price check” is not the correct terminology anymore, change it to “log price”
    - Leaning towards what was recently logged (ex. Great Value Chicken Eggs) and what was shown in recents is “Chicken Eggs”
        - Can jump back to market price page he has
    - Location is awesome!
    - Main suggestion: keep things in the same spot as much as possible (for example, the exit button for search and price checks not being in the same place)
    - Merge shopping cart or have cart/list considered as navigation item
        - Have a sidebar for cart/shopping list
    - Simplify cart and list (merge them)
        - Assume that if they check something off, then they are going to buy it
- Discussing sub-teams (frontend, backend, database)
    - Database
        - Are we using pre-existing database? We are welcome to use it
        - What are we putting in database? Leave it to team to make that call, Metro has a dedicated page for deals (scrape deals page because it’s a dedicated URL and will be scalable to categories for him to scale latterly), if it hits a hiccup then we can error-handle it
            - Scrape information on Metro deals page where all values already appear (product name, unit price, etc.), but the only thing missing is category
                - Go to categories → filter by deals → scrape
        - On client-side, if scrapper can be in a state where he can scale it up, that would be ideal and important
        - Has a survey on what is in-demand
            - Wants to look at produce items more than packaged items (meat, vegetable, fruits, dairy)
            - Weights are a problem area people want to price-check
        - It might be beneficial to have a lightweight ML (anytime there’s “raspberries” and “aspberries”, the error is handled accordingly)
        - Can go through DoS and submit SQL queries through API
        - Keep in mind with Supabase, if you were to submit data through application, you might hit role level security (each table has policies set to them, like the seller table, only has access for users to read it), but through API credentials, we shouldn’t run into these issues
        - He’s okay with us creating new databases and modifications to existing tables
          
## Meeting #4 (10/14/23)
