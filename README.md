# wherewolf [![Build Status](https://secure.travis-ci.org/madpilot/wherewolf.png)](http://travis-ci.org/madpilot/wherewolf) [![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)

Makes adding filtering and searching to your REST API crazy easy.

## Problem

Most RESTful APIs expose a "/index" endpoint that return all of objects at a given endpoint. That is fine until you need the ability to filter them.

Consider the following scenario:

    /players.json 

But what if I want only players that are active? Most developers would simply add a query parameter like so:

    /players.json?active=true

Ok, now what if you only want players capped after the first of January 2012? Maybe:

    /players.json?first_cap=2012-01-01

Yeah, great - but it doesn't really scale. Wouldn't if be better if we could do something like this?

    /players.json?where=active%20%3D%20true%20%26%26%20first_cap%20%3E%3D%202012-01-01

Ok, it doesn't read amazingly, but this is an API, so encoding that stuff is trivial for the client. For those of you that doesn't speak URI-encoded string that is the same as:

    active = true && first_cap >= 2012-01-01

Wherewolf will take that string and converts it in to ARel, so your clients can run arbitary queries against your API.

## Get started

The easiest way is to use Bundler:

    gem 'wherewolf'

Then for every model that you want to by queryable, do this:

```ruby
class Player < ActiveRecord::Base
  has_query_parsing
end
```

This will add the "where_query" and "order_query" methods, which you pass your query string in to.

has_query_parsing can take two options: whitelist and blacklist which allow you to set which columns consumers can search against

Setting whitelist will mean ONLY those columns will be searchable

```ruby
class Player < ActiveRecord::Base
  has_query_parsing :whitelist => [ :name ]   # Only name will be searchable
end

Setting blacklist will remove those columns from the list

class Player < ActiveRecord::Base
  has_query_parsing :blacklist => [ :name ]   # Name will not be searchable
end
```

Both whitelist and blacklist can take a proc if you want to lazy evaluate

```ruby
class Player < ActiveRecord::Base
  has_query_parsing :whitelist => proc { |model| model.accessible_attributes.map(&:to_sym) }
end
```

would restrict the searchable columns to those exposed by accessible_attributes

## Example

For a real-life, running example, check out: http://wherewolf.herokuapp.com/

```ruby
player = Player.where_query("(position = wing || position = lock) && first_cap < 1905-01-01").order('first_cap')
# Returns all players that play 'wing' or 'lock', and played before 1905-01-01

player = Player.where_query('name = "John Eales"')
# Returns all players names 'John Eales'

player = Player.where_query("first_cap >= 1905-01-01 && active = false")
# Returns all inactitve players that played after 1905-01-01.

player = Player.where_query("first_cap != null")
# Returns all players who have received their first cap (ie first_cap is NOT nil)

player = Player.where_query('name ~= "Peter%"')
# Returns all players who's name starts with Peter
```

As you can see, where_query returns an ARel object, so you chain other statements to it.

## Order

You can also supply an order_query to handle ordering

```ruby
player = Player.order_query("name asc")
# Order by name asc

player = Player.order_query("name desc")
# Order by name desc

player = Player.order_query("name")
# By default ordering is ascending

player = Player.order_query("name desc, position desc")
# You can also have multiple order columns
```

Of course, you can nest them...

```ruby
player = Player.where_query("first_cap != null").order_query('name desc')
```

## Errors

At the moment, error handling is very primitive. Just capture

```ruby
Wherewolf::ParseError
```

You can print out a simple error message like so

```ruby
begin
  Player.where_query('name ~= "Patrick%" || (position = "fail)')
rescue Wherewolf::ParseError => e
  puts e.error_message
end
```

Will print out

    Parsing error occured at character 28

You can get the character number by:

```ruby
begin
  Player.where_query('name ~= "Patrick%" || (position = "fail)')
rescue Wherewolf::ParseError => e
  e.position # This value will be 28
end
```

## To Do

* Better error messages (Give a clue as to why parsing failed)
* Aliases such for operators, such as 'and', 'or' etc
* Allow single quotes around strings
* More edge case testing
* Ability to call named scopes

## Contributing to wherewolf
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 [MadPilot Productions](http://www.madpilot.com.au/). See LICENSE.txt for further details.
