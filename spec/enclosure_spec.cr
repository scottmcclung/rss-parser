require "./spec_helper"
require "../src/rss/models/enclosure"

describe RSS::Enclosure do
  describe ".from_xml" do
    it "parses enclosure with all attributes" do
      node = XML.parse("<enclosure url='http://example.com/file.mp3' length='12345' type='audio/mpeg'>").first_element_child
      raise "Expected the enclosure node to exist" if node.nil?

      enclosure = RSS::Enclosure.from_xml(node)

      enclosure.url.should eq "http://example.com/file.mp3"
      enclosure.length.should eq 12345
      enclosure.type.should eq "audio/mpeg"
    end

    it "parses missing optional attributes" do
      node = XML.parse("<enclosure url='http://example.com/file.png'>").first_element_child
      raise "Expected the enclosure node to exist" if node.nil?

      enclosure = RSS::Enclosure.from_xml(node)

      enclosure.url.should eq "http://example.com/file.png"
      enclosure.length.should eq 0_i64
      enclosure.type.should eq ""
    end
  end
end
