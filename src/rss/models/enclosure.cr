# An item's enclosure element associates a media object such as an audio or video file with the item.
#
# The element MUST have three attributes:
#   - length: Indicates the size of the file in bytes
#   - type: Identifies the file's MIME media type
#   - url: Identifies the URL of the file
#
# Example
# ```xml
#   <enclosure length="24986239" type="audio/mpeg" url="http://dallas.example.com/joebob_050689.mp3" />
# ```
#

require "./model"

module RSS
  struct Enclosure < Model
    property url : String?
    property length : Int64?
    property type : String?

    private def initialize(@url, @length, @type); end

    def self.from_xml(node : XML::Node) : Enclosure
      url = node["url"]? || ""
      length = node["length"]?.try &.to_i64 || 0_i64
      type = node["type"]? || ""

      new(url: url, length: length, type: type)
    end
  end
end
