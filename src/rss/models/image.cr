# The image element supplies a graphical logo for the feed (OPTIONAL).
#
# The image MUST contain three child elements: link, title and url.
# It also MAY contain three OPTIONAL elements: description, height and width.
#
# Image elements
#   - link: The image's link element identifies the URL of the web site represented by the image (REQUIRED).
#   - title: The image's title element holds character data that provides a human-readable description of the image (REQUIRED).
#   - url: The image's url element identifies the URL of the image, which MUST be in the GIF, JPEG or PNG formats (REQUIRED).
#   - description: The image's description element holds character data that provides a human-readable characterization
#                  of the site linked to the image (OPTIONAL).
#   - height: The image's height element contains the height, in pixels, of the image (OPTIONAL).
#             The image MUST be no taller than 400 pixels. If this element is omitted, the image is assumed to be 31 pixels tall.
#   - width: The image's width element contains the width, in pixels, of the image (OPTIONAL).
#            The image MUST be no wider than 144 pixels. If this element is omitted, the image is assumed to be 88 pixels wide.
#
# Example
# ```xml
# <image>
#   <link>http://dallas.example.com</link>
#   <title>Dallas Times-Herald</title>
#   <url>http://dallas.example.com/masthead.gif</url>
#   <description>Read the Dallas Times-Herald</description>
#   <height>32</height>
#   <width>96</width>
# </image>
# ```
#
# See https://www.rssboard.org/rss-profile#data-types-characterdata for more information about 'character data'
#

require "./model"

module RSS
  struct Image < Model
    getter url : String
    getter title : String
    getter link : String
    getter height : Int32
    getter width : Int32
    getter description : String

    private def initialize(@url, @title, @link, @width, @height, @description); end

    def self.from_xml(node : XML::Node) : Image
      url = content_from_xpath("url", node) || ""
      title = content_from_xpath("title", node) || ""
      link = content_from_xpath("link", node) || ""
      height = content_from_xpath("height", node).try &.to_i32 || 31_i32
      width = content_from_xpath("width", node).try &.to_i32 || 88_i32
      description = content_from_xpath("description", node) || ""

      new(url: url, title: title, link: link, width: width, height: height, description: description)
    end
  end
end
