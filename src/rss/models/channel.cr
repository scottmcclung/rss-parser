# The channel element describes the RSS feed, providing such information as its title and description,
# and contains items that represent discrete updates to the web content represented by the feed.
#
# This element is REQUIRED and MUST contain three child elements: description, link and title.
# The channel MAY contain each of the following OPTIONAL elements: category, cloud, copyright, docs, generator,
# image, language, lastBuildDate, managingEditor, pubDate, rating, skipDays, skipHours, textInput, ttl and webMaster.
#
# The preceding elements MUST NOT be present more than once in a channel, with the exception of category.
# The channel also MAY contain zero or more item elements. The order of elements within the channel MUST NOT be treated as significant.
#
# Required channel elements:
#
# title
#   - Holds character data that provides the name of the feed (REQUIRED).
# link
#   - Identifies the URL of the web site associated with the feed (REQUIRED).
# description
#   - Holds **character data** that provides a human-readable characterization or summary of the feed (REQUIRED).
#
#
# Optional channel elements:
#
# language
#   - Identifies the natural language employed in the feed (OPTIONAL).
# copyright
#   - Declares the human-readable copyright statement that applies to the feed (OPTIONAL).
# managing_editor
#   - Provides the e-mail address of the person to contact regarding the editorial content of the feed (OPTIONAL).
# web_master
#   - Provides the e-mail address of the person to contact about technical issues regarding the feed (OPTIONAL).
# publication_date
#   - Indicates the publication date and time of the feed's content (OPTIONAL).
# last_build_date
#   - Indicates the last date and time the content of the feed was updated (OPTIONAL).
# categories
#   - Identifies a category or tag to which the feed belongs (OPTIONAL).
#   - A channel MAY contain more than one category element.
# generator
#   - Credits the software that created the feed (OPTIONAL).
# docs
#   - Identifies the URL of the RSS specification implemented by the software that created the feed (OPTIONAL).
# cloud
#   - Indicates that updates to the feed can be monitored using a web service that implements the RssCloud application programming interface (OPTIONAL).
# ttl
#   - Represents the feed's time to live (TTL)
#   - The maximum number of minutes to cache the data before an aggregator requests it again (OPTIONAL).
# images
#   - Supplies a graphical logo for the feed (OPTIONAL).
# rating
#   - Supplies an advisory label for the content in a feed, formatted according to the specification for the
#   - Platform for Internet Content Selection (PICS) (OPTIONAL).
# text_input
#   - Defines a form to submit a text query to the feed's publisher over the Common Gateway Interface (CGI) (OPTIONAL).
# skip_hours
#   - Identifies the hours of the day during which the feed is not updated (OPTIONAL).
#   - This element contains individual hour elements identifying the hours to skip.
#   - The hour element identifies an hour of the day in Greenwich Mean Time (GMT).
#   - The hour MUST be expressed as an integer representing the number of hours since 00:00:00 GMT.
#   - Values from 0 to 23 are permitted, with 0 representing midnight.
# skip_days
#   - Identifies days of the week during which the feed is not updated (OPTIONAL).
#   - This element contains up to seven day elements identifying the days to skip.
#   - The day element identifies a weekday in Greenwich Mean Time (GMT)
# items
#   - Represents distinct content published in the feed such as a news article,
#     weblog entry or some other form of discrete update.
#   - A channel MAY contain any number of items (or no items at all).
#
#
# Example
# ```xml
# <channel>
#   <description>Current headlines from the Dallas Times-Herald newspaper</description>
#   <link>http://dallas.example.com</link>
#   <title>Dallas Times-Herald</title>
#   <category domain="dmoz">News/Newspapers/Regional/United_States/Texas</category>
#   <copyright>Copyright 2007 Dallas Times-Herald</copyright>
#   <docs>https://www.rssboard.org/rss-specification</docs>
#   <generator>Microsoft Spaces v1.1</generator>
#   <language>epo</language>
#   <pubDate>Sun, 14 Oct 2007 05:00:00 GMT</pubDate>
#   <lastBuildDate>Sun, 14 Oct 2007 17:17:44 GMT</lastBuildDate>
#   <managingEditor>jlehrer@dallas.example.com (Jim Lehrer)</managingEditor>
#   <webMaster>helpdesk@dallas.example.com</webMaster>
#   <rating>(PICS-1.1 "http://www.rsac.org/ratingsv01.html" l by "webmaster@example.com" on "2007.01.29T10:09-0800" r (n 0 s 0 v 0 l 0))</rating>
#   <ttl>60</ttl>
#   <skipDays>
#     <day>Saturday</day>
#     <day>Sunday</day>
#   </skipDays>
#   <skipHours>
#     <hour>0</hour>
#     <hour>1</hour>
#     <hour>2</hour>
#     <hour>22</hour>
#     <hour>23</hour>
#   </skipHours>
#   <textInput>
#     <description>Your aggregator supports the textInput element. What software are you using?</description>
#     <link>http://www.cadenhead.org/textinput.php</link>
#     <name>query</name>
#     <title>TextInput Inquiry</title>
#   </textInput>
#   <cloud domain="server.example.com" path="/rpc" port="80" protocol="xml-rpc" registerProcedure="cloud.notify" />
#   <image>
#     <link>http://dallas.example.com</link>
#     <title>Dallas Times-Herald</title>
#     <url>http://dallas.example.com/masthead.gif</url>
#     <description>Read the Dallas Times-Herald</description>
#     <height>32</height>
#   </image>
# </channel>
# ```
# See https://www.rssboard.org/rss-profile#data-types-characterdata for more information about 'character data'
#
# TODO: Handle character data properly

require "./model"
require "./category"
require "./image"
require "./cloud"
require "./item"
require "./text_input"

module RSS
  struct Channel < Model
    getter title : String
    getter link : String
    getter description : String
    getter language : String
    getter copyright : String
    getter managing_editor : String
    getter web_master : String
    getter publication_date : Time?
    getter last_build_date : Time?
    getter categories : Array(RSS::Category)
    getter generator : String
    getter docs : String
    getter cloud : RSS::Cloud?
    getter ttl : Int32?
    getter images : Array(RSS::Image)
    getter rating : String
    getter text_input : TextInput?
    getter skip_hours : Array(Int32)
    getter skip_days : Array(String)
    getter items : Array(Item)

    private def initialize(
      @title,
      @link,
      @description,
      @language,
      @copyright,
      @managing_editor,
      @web_master,
      @publication_date,
      @last_build_date,
      @categories,
      @generator,
      @docs,
      @cloud,
      @ttl,
      @images,
      @rating,
      @text_input,
      @skip_hours,
      @skip_days,
      @items
    )
    end

    def self.from_xml(node : XML::Node) : Channel
      title = content_from_xpath("title", node) || ""
      link = content_from_xpath("link", node) || ""
      description = content_from_xpath("description", node) || ""
      language = content_from_xpath("language", node) || ""
      copyright = content_from_xpath("copyright", node) || ""
      managing_editor = content_from_xpath("managingEditor", node) || ""
      web_master = content_from_xpath("webMaster", node) || ""
      publication_date = content_from_xpath("pubDate", node).try { |node| Time.parse_rfc2822(node) }
      last_build_date = content_from_xpath("lastBuildDate", node).try { |node| Time.parse_rfc2822(node) }
      categories = nodes_from_xpath("category", node).map { |node| RSS::Category.from_xml(node) } || [] of RSS::Category
      generator = content_from_xpath("generator", node) || ""
      docs = content_from_xpath("docs", node) || ""
      cloud = node_from_xpath("cloud", node).try { |node| RSS::Cloud.from_xml(node) }
      ttl = content_from_xpath("ttl", node).try &.to_i32
      images = nodes_from_xpath("image", node).map { |node| RSS::Image.from_xml(node) } || [] of RSS::Image
      rating = content_from_xpath("rating", node) || ""
      text_input = node_from_xpath("textInput", node).try { |node| RSS::TextInput.from_xml(node) }

      skip_hours = node_from_xpath("skipHours", node).try do |sh_node|
        nodes_from_xpath("hour", sh_node).map { |hour| hour.content.to_i32 }
      end
      skip_hours ||= [] of Int32

      skip_days = node_from_xpath("skipDays", node).try do |sd_node|
        nodes_from_xpath("day", sd_node).map { |day| day.content }
      end
      skip_days ||= [] of String

      items = nodes_from_xpath("item", node).map { |node| RSS::Item.from_xml(node) } || [] of RSS::Item

      new(
        title: title,
        link: link,
        description: description,
        language: language,
        copyright: copyright,
        managing_editor: managing_editor,
        web_master: web_master,
        publication_date: publication_date,
        last_build_date: last_build_date,
        categories: categories,
        generator: generator,
        docs: docs,
        cloud: cloud,
        ttl: ttl,
        images: images,
        rating: rating,
        text_input: text_input,
        skip_hours: skip_hours,
        skip_days: skip_days,
        items: items,
      )
    end
  end
end
