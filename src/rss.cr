require "./rss/*"

# Really Simple Syndication (RSS) is an XML-based document format for the syndication of web content so that it
# can be republished on other sites or downloaded periodically and presented to users.
# The RSS 2.0 specification describes how to create RSS documents.
module RSS
  def self.parse(xml_content : String)
    rss_root_node = XML.parse(xml_content).first_element_child
    if rss_root_node.nil? || rss_root_node.name != "rss"
      raise RSSParsingError.new("Expected a valid rss node at the document root")
    end
    channel_node = rss_root_node.first_element_child
    if channel_node.nil? || channel_node.name != "channel"
      raise RSSParsingError.new("Expected a valid channel node under the rss node")
    end
    RSS::Channel.from_xml(channel_node)
  end

  class RSSParsingError < Exception; end
end
