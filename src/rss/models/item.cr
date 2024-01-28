# An item element represents distinct content published in the feed such as a news article,
# weblog entry or some other form of discrete update. A channel MAY contain any number of
# items (or no items at all).
# An item MAY contain the following child elements: author, category, comments, description,
# enclosure, guid, link, pubDate, source and title. All of these elements are OPTIONAL
# but an item MUST contain either a title or description.
# The preceding elements MUST NOT be present more than once in an item, with the exception of category.
#
# Item elements
#   - title: Holds character data that provides the item's headline. This element is OPTIONAL if the item contains a description element.
#   - link: Identifies the URL of a web page associated with the item.
#   - author: Provides the e-mail address of the person who wrote the item.
#   - category: Identifies a category or tag to which the item belongs. This element MAY include a domain attribute that identifies the category's taxonomy.
#   - comments: Identifies the URL of a web page that contains comments received in response to the item.
#   - description: An item's description element holds character data that contains the item's full content or a summary of its contents,
#                  a decision entirely at the discretion of the publisher. This element is OPTIONAL if the item contains a title element.
#                  The description MUST be suitable for presentation as HTML. HTML markup MUST be encoded as character data either by
#                  employing the HTML entities &lt; ("<") and &gt; (">") or a CDATA section.
#   - enclosure: Associates a media object such as an audio or video file with the item.
#   - guid: Provides a string that uniquely identifies the item (OPTIONAL). The guid MAY include an isPermaLink attribute.
#           The guid enables an aggregator to detect when an item has been received previously and does not need to be presented
#           to a user again. If the guid's isPermaLink attribute is omitted or has the value "true", the guid MUST be the permanent
#           URL of the web page associated with the item.
#           If the guid's isPermaLink attribute has the value "false", the guid MAY employ any syntax the feed's publisher has
#           devised for ensuring the uniqueness of the string, such as the Tag URI scheme described in RFC 4151.
#   - pubDate: Indicates the publication date and time of the item.
#   - source:  Indicates the fact that the item has been republished from another RSS feed.
#              The element MUST have a url attribute that identifies the URL of the source feed.
#
# Example
# ```xml
# <item>
#   <title>Seventh Heaven! Ryan Hurls Another No Hitter</title>
#   <link>http://dallas.example.com/1991/05/02/nolan.htm</link>
#   <description>I'm headed for France. I wasn't gonna go this year, but then last week &lt;a href="http://www.imdb.com/title/tt0086525/"&gt;Valley Girl&lt;/a&gt; came out and I said to myself, Joe Bob, you gotta get out of the country for a while.</description>
#   <author>jbb@dallas.example.com (Joe Bob Briggs)</author>
#   <category>movies</category>
#   <category domain="rec.arts.movies.reviews">1983/V</category>
#   <comments>http://dallas.example.com/feedback/1983/06/joebob.htm</comments>
#   <enclosure length="24986239" type="audio/mpeg" url="http://dallas.example.com/joebob_050689.mp3" />
#   <guid isPermaLink="false">tag:dallas.example.com,4131:news</guid>
#   <pubDate>Fri, 05 Oct 2007 09:00:00 CST</pubDate>
#   <source url="http://la.example.com/rss.xml">Los Angeles Herald-Examiner</source>
# </item>
# ```
#
#
#

require "./model"
require "./guid"
require "./source"
require "./category"
require "./enclosure"

module RSS
  struct Item < Model
    getter link : String
    getter title : String
    getter author : String
    getter guid : RSS::Guid?
    getter comments : String
    getter source : RSS::Source?
    getter description : String
    getter publication_date : Time?
    getter enclosure : RSS::Enclosure?
    getter categories : Array(RSS::Category)

    private def initialize(
      @guid,
      @link,
      @title,
      @author,
      @source,
      @comments,
      @enclosure,
      @categories,
      @description,
      @publication_date
    ); end

    def self.from_xml(node : XML::Node) : Item
      link = content_from_xpath("link", node) || ""
      title = content_from_xpath("title", node) || ""
      author = content_from_xpath("author", node) || ""
      comments = content_from_xpath("comments", node) || ""
      description = content_from_xpath("description", node) || ""
      guid = node_from_xpath("guid", node).try { |node| RSS::Guid.from_xml(node) }
      source = node_from_xpath("source", node).try { |node| RSS::Source.from_xml(node) }
      publication_date = content_from_xpath("pubDate", node).try { |x| Time.parse_rfc2822(x) }
      categories = nodes_from_xpath("category", node).map { |cat_xml| RSS::Category.from_xml(cat_xml) }
      enclosure = nodes_from_xpath("enclosure", node).map { |enc_xml| RSS::Enclosure.from_xml(enc_xml) }.first?

      new(
        guid: guid,
        link: link,
        title: title,
        author: author,
        source: source,
        comments: comments,
        enclosure: enclosure,
        categories: categories,
        description: description,
        publication_date: publication_date,
      )
    end
  end
end
