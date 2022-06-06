# API Engineering Assignment

### Overview

The goals of this assignment are to:

1. Consume data from a publicly-available sports API
2. Parse and sanitize the data
3. Store it in the new sanitized format for retrieval later

### Instructions

Clone this repository template, and with the language of your choosing, create a new project in the `code/` directory.

Your task is to write a program that consumes this endpoint: `https://sports.core.api.espn.com/v2/sports/football/leagues/nfl/athletes`, then iterates over the individual athlete endpoints returned by that call, and create sanitized `athlete` objects.

The `athlete` objects should match the following structure:

```
{
  "id": "",
  "firstName": "",
  "lastName": "",
  "fullName": "",
  "age":"",
  "ageLabel": "",
  "team": {
    "name": "",
    "location": "",
    "displayName: "",
    "color": "",
    "alternateColor": ""
  }
},

...
```

### Requirements

**Consuming Data:**
- You should iterate over the first 10 pages of the endpoint (to return an intermediate set of 250 records).

**Parsing and Sanitizing the Data:**
- Reject any record whose `"firstName"` field is an empty string. You should not store that record in the intermediate set.
- `ageLabel` is a new data field which should be dynamically set as `Senior` or `Junior` for each athlete. Set the value to `Senior` if the athlete's age is equal to or greater than the average athlete age across the intermediate set. Set the value to `Junior` if the athlete's age is below the average athlete age.

**Storing Data:**
- All athlete objects should be stored in either a NoSQL database format or a file called `output.json` in the `code/` directory.

### Closing

All project files should be delivered via Github within 72 hours of receiving the assignment with instructions to run the application locally. Best of luck!

