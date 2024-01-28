# An item's guid element provides a string that uniquely identifies the item. The guid MAY include an isPermaLink attribute.
# The guid enables an aggregator to detect when an item has been received previously and does not need to be presented to
# a user again. If the guid's isPermaLink attribute is omitted or has the value "true", the guid MUST be the permanent
# URL of the web page associated with the item.
# If the guid's isPermaLink attribute has the value "false", the guid MAY employ any syntax the feed's publisher has
# devised for ensuring the uniqueness of the string, such as the Tag URI scheme described in RFC 4151.
#
# Example
# ```xml
#   <guid>http://dallas.example.com/1983/05/06/joebob.htm</guid>
#   <guid isPermaLink="false">tag:dallas.example.com,4131:news</guid>
# ```
#

require "./model"

module RSS
  struct Guid < Model
    getter is_perma_link : Bool
    getter content : String

    private def initialize(@is_perma_link, @content); end

    def self.from_xml(node : XML::Node) : Guid
      is_perma_link = node["isPermaLink"]? ? true : false
      content = node.content || ""

      new(is_perma_link: is_perma_link, content: content)
    end
  end
end
