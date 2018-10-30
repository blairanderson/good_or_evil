# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# sources and feeds should be separated!

sources = [
  {
    title: "New York Times - HomePage",
    url: "https://www.nytimes.com",
    feed_url: "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
  },
  {
    title: "New York Times Business",
    url: "https://www.nytimes.com/section/business",
    feed_url: "https://www.nytimes.com/svc/collections/v1/publish/https://www.nytimes.com/section/business/rss.xml"
  },
  {
    title: "New York Times Politics",
    url: "https://www.nytimes.com/section/politics",
    feed_url: "https://www.nytimes.com/svc/collections/v1/publish/https://www.nytimes.com/section/politics/rss.xml"
  },
  {
    title: "BBC World",
    url: "https://www.bbc.com/news/world",
    feed_url: "http://feeds.bbci.co.uk/news/world/rss.xml"
  }, {
    title: "BBC Sports",
    url: "https://www.bbc.com/news/business",
    feed_url: "http://feeds.bbci.co.uk/news/business/rss.xml"
  }, {
    title: "BBC Science",
    url: "https://www.bbc.com/news/science_and_environment",
    feed_url: "http://feeds.bbci.co.uk/news/science_and_environment/rss.xml"
  }, {
    title: "AlJazeera",
    url: "https://www.aljazeera.com",
    feed_url: "https://www.aljazeera.com/xml/rss/all.xml"
  }, {
    # CNN
    title: "CNN World News",
    url: "https://edition.cnn.com/world",
    feed_url: "http://rss.cnn.com/rss/edition_world.rss"
  }, {
    # guardian
    title: "Guardian World News",
    url: "https://www.theguardian.com/world",
    feed_url: "https://www.theguardian.com/world/rss"
  }
]

Source.create([

  ])
