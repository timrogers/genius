# Genius

[![Build Status](https://travis-ci.org/timrogers/genius.svg)](https://travis-ci.org/timrogers/genius)
[![Gem Version](https://badge.fury.io/rb/genius.svg)](http://badge.fury.io/rb/genius)

![Genius logo](http://assets.rapgenius.com/images/apple-touch-icon.png?1432674944)

## What does this do?

It's a Ruby gem for accessing songs, artists and annotations on
[Genius](http://genius.com), based on the original [rapgenius](https://github.com/timrogers/rapgenius) gem.

## Installation

Install the gem, and you're ready to go. Simply add the following to your Gemfile:

```ruby
gem "genius", "~> 0.1.0"
```

## Usage

The best way to get a decent idea of the attributes available on `Song` and
the other objects is by checking out the API documentation at:
https://docs.genius.com

### Authentication

You'll need to set your access token before using the library. You can create a client and grab an access token from
<http://genius.com/api-clients>. You can then use that like so:

``` ruby
Genius.access_token = 'your-access-token'
```

At the moment, this library isn't set up for a traditional multi-user OAuth setup - despite the Genius API being [based](https://docs.genius.com/#/authentication-h1) on OAuth. It's built for the use case of just accessing the API with your account. This may change in future.

### Configuration

The library has one configuration option letting you choose between response formats between `plain`, `html` and `dom` - this is the [`text_format` option in the API](https://docs.genius.com/#/response-format-h1).

It'll default to `plain`, meaning you'll get back plain texts from API fields which return rich resources (artists' descriptions or annotations' contents). You can change this like so:

```ruby
Genius.text_format = "html"
```

### Songs

You can find a song by name, or using it's unique ID.

To find a song by name, use `Genius::Song.search` like this:

```ruby
songs = Genius::Song.search("The Hills") # Returns an array of Song objects
the_hills = songs.first
the_hills.title # => "The Hills"
the_hills.primary_artist.name # => "The Weeknd"
```

Alternatively, you can find a song by it's unique ID. They're not especially easy to find, but if you hover over the "PYONG!" button near the top of the page, you'll see the song's ID in the URL. Once you have an ID, you can load a song via the API:

```ruby
song = Genius::Song.find(176872)
song.title # => "Versace"
song.primary_artist.name # => "Migos"
```

Once you've found the song you're looking for, there are plenty of other useful details you can access:

```ruby
song.title
# => "Versace"

song.url
# => "http://genius.com/Migos-versace-lyrics"

song.pyongs_count
# => 198

song.description
# => "Released in June 2013, not only did they take the beat from Soulja Boy’s OMG part 2 but they absolutely killed it."
```

Check out [song.rb](https://github.com/timrogers/genius/blob/master/lib/genius/song.rb) or the [Genius API documentation](https://docs.genius.com/#songs-h2) for a full list of available fields.

### Artist

You can find artists from their songs (e.g. `Song#primary_artist`) and a couple of other places, or you can find them by their ID. As with songs, artists' IDs are pretty tricky to find, but you can get them by hovering over the "Follow" button on an artist's page on the Genius site.

```ruby
the_hills = Genius::Song.find(727466)
the_weeknd = the_hills.primary_artist

# or...

the_weeknd = Genius::Artist.find(2358)
```

Once you've found the artist you're looking for, you can then query its attributes:

```ruby
artist.name
# => "The Weeknd"

artist.description
# => "Abel Tesfaye (otherwise known as The Weeknd)..."

# You can even find the artist's songs with the #songs method
artist.songs # => [<Genius::Song...]
```

Check out [artist.rb](https://github.com/timrogers/genius/blob/master/lib/genius/artist.rb) or the [Genius API documentation](https://docs.genius.com/#artists-h2) for a full list of available fields.

### Account

You can access your user profile with the `Genius::Account.me` method:

```ruby
me = Genius::Account.me
```

From there, you can get access to a range of attributes:

```ruby
me.name
# => "timrogers"

me.iq
# => 1691
```

Check out [account.rb](https://github.com/timrogers/genius/blob/master/lib/genius/account.rb) or the [Genius API documentation](https://docs.genius.com/#account-h2) for a full list of available fields.

### Other resources

The API library also supports working with web pages, annotations and referents in the API. See the [Genius API documentation](https://docs.genius.com/#account-h2) and the library [source](https://github.com/timrogers/genius/tree/master/lib/genius).

## Contributing

If you'd like to contribute anything else, go ahead or better still, make an issue and we can talk it over and spec it out! A few quick tips:

* Don't update the version numbers before your pull request - I'll sort that part out for you.
* Make sure you write specs, then run them with `$ bundle exec rake`. When running tests, you'll want to set `GENIUS_ACCESS_TOKEN` so your requests can be authenticated - don't worry, your token will be filtered out of the `vcr` cassettes.
* Update this README.md file so I, and users, know how your changes work

## Copyright

Copyright (c) 2015 Tim Rogers. See LICENSE for details.

## Get in touch

Any questions, thoughts or comments? Email me at <me@timrogers.co.uk> or create an issue.
