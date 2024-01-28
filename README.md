# RSS Parser

A utility to parse the xml of an RSS feed.  This is still a work in progress so it may not handle all the edge cases very well yet.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     rss_parser:
       github: scottmcclung/rss_parser
   ```

2. Run `shards install`

## Usage

To parse an RSS feed, provide the XML content to the RSS Parser:

```crystal
require "rss_parser"

xml_content = # Fetch or read your RSS feed XML content as a string (ensure the content has been sanitized)
begin
  rss_feed = RSS.parse(xml_content)
  # Work with the parsed rss_feed object
rescue RSS::RSSParsingError => e
  puts "Failed to parse RSS feed: #{e.message}"
end
```

After parsing, you can access various elements of the feed. For example:

```crystal
rss_feed.title # Access the feed title
rss_feed.items.each do |item|
  puts item.title   # Title of each item
  puts item.link    # Link of each item
  # Access other properties like item.description, item.pubDate, etc.
end
```


## Contributing

1. Fork it (<https://github.com/scottmcclung/rss_parser/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Scott McClung](https://github.com/scottmcclung) - creator and maintainer
