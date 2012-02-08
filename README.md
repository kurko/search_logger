#Search Logger

This is a concept app that will:

* read a XML file containing keywords
* search on Google for each one of them, returning 2 pages with 100 results each
* store the keyword, position, title, description and url of the result into a MySQL database
* read all data from the database and create a CSV file

Tested on:

* Mac OS X Lion
* Linux
* Ruby 1.9.2 and 1.9.3

It'll probably not work on Windows or Ruby 1.8.7.

##Comments

Although a request to Google asks for 100 results, the returned quantity will vary
depending on the keyword. Some of them include videos and news, which sometimes will
result in i.e. 103 results.

I decided to not use the Custom Search API because I'd be able to make only a few requests
before being blocked (and a limitation of 10 results per page).
I went with Nokogiri, just interpreting the returned HTML.

There are some things I'd refactor, but because they're not critical (and I'm out of time)
they'll remain as they are. Some of them:

* Parsing and adjusting descriptions is something that would be required. I
removed the basic links and unrelated words, but some more polishing work would be necessary.
* Google returns news and videos amongst websites, which I don't know if you consider
as a valid result or not. I left them appearing in the database anyway, but that would be
easy to remove because we have a good test coverage.
* The CSV Ruby standard library doesn't invert Hebrew strings, but leave 'position' out of place.
I didn't have enough time to investigate, but that's something I'd work on next.
* There's a created_at field on the database table, but no date is saved there.
* I'd better stub third-party services like Google and the database.

## How to use

First, run this SQL in your MySQL database:

    DROP DATABASE IF EXISTS search_logger;
    CREATE DATABASE search_logger;
    USE search_logger;

    CREATE TABLE google_results(
      id int auto_increment,
      searched_keyword varchar(250),
      title text,
      url text,
      description text,
      position int,
      created_at datetime,
      PRIMARY KEY(id)
    ) DEFAULT CHARACTER SET utf8;
    CREATE INDEX position_idx ON google_results(position);

Install the gem:

`gem install search_logger`

Then, run it, appending the path the XML file containing the keywords:

`search_logger ~/path/to/the/xml_file.xml`

Follow the on-screen instructions, typing your database configuration. If Google
doesn't change his HTML format, everything should work alright.

