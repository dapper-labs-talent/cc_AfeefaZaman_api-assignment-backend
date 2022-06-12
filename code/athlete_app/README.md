# Rails App For Storing Athletes

## Dependencies
* Ruby version 2.5.1
* Rails version 6
* MongoDB

Some external gems were used to better manage the api:

* `mongoid`
Used to store Athletes and Teams in a NoSQL DB, and manipulate the data
* `typhoeus`
Used to send Asynchronous http requests to ESPN API

All dependencies are listed in `Gemfile` and versioning in `Gemfile.lock`

## Setup
You need to install the specified versions of Ruby and Rails.
You need to have `mongodb-community@5.0` installed and started

* Run the following command to setup environment
```
bundle install
```

## Starting server
* Run the following command to start server
```
rails s
```

## To run the service manually
* Use the following commands to consume and sanitize date through console
```
rails c
AthleteService.new.execute
```
* You can change following parameters for `fetch_athletes(pages, expand, properties, limit_per_page)`:
    - pages (Number of pages to get from ESPN Sports API)
    - expand (This array can include any expandable properties of Athlete and there required fields)
    - properties (This array can inclued any required (unexpandable) fields of Athlete)
    - limit_per_page (This number will limit athlete items on a page of ESPN API)
* You You can change following parameter for `create_athletes(athletes, clear_collection)`:
    - clear_collection (giving `true` will destroy all previously saved athletes before creating new)

## Assupmtions
This project was developed under the following assumptions
- The dynamic field `ageLimit` should be calulated after all the data has been fetched from the API
- Any fields other than `firstName` should not be validated
- ESPN API response formats will remain the same
- Creating an API is not a requirment but is developed for useability
- A View-free and ActiveRecord-free application is sufficient as per the requirements


## Possible Improvements
The application was built to complete the requirements described in the task. To make this a fully functional production ready code, I suggest to consider improving a few things:
- Better error handling: Use an external library to manage error responses and handle edge cases properly
- APIs that allow to perform CRUD operations and other operations needed to manipulate Data as required
- Env variables and configurations to secure database and APIs
- Better route handing supporting API versioning
- Test cases using Rspec and web mocks
