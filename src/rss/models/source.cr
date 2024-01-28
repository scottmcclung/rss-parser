# An item's source element indicates the fact that the item has been republished from another RSS feed.
# The value of the source is the title of the source feed.
# The element MUST have a url attribute that identifies the URL of the source feed.
#
# Example
# ```xml
#   <source url="http://la.example.com/rss.xml">Los Angeles Herald-Examiner</source>
# ```
#

require "./model"

module RSS
  struct Source < Model
    getter url : String
    getter content : String

    private def initialize(@url, @content); end

    def self.from_xml(node : XML::Node) : Source
      url = node["url"]? || ""
      content = node.content || ""

      new(url: url, content: content)
    end
  end
end
