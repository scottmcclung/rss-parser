require "./spec_helper"
require "../src/rss/models/guid"

describe RSS::Guid do
  describe ".from_xml" do
    it "parses guid with domain" do
      node = XML.parse("<guid isPermaLink=\"true\">http://dallas.example.com/1983/05/06/joebob.htm</guid>").first_element_child
      raise "Expected the guid node to exist" if node.nil?

      guid = RSS::Guid.from_xml(node)

      guid.is_perma_link.should_not be_nil
      guid.is_perma_link.should eq true
      guid.content.should eq "http://dallas.example.com/1983/05/06/joebob.htm"
    end

    it "parses guid without is_perma_link" do
      node = XML.parse("<guid>http://dallas.example.com/1983/05/06/joebob.htm</guid>").first_element_child
      raise "Expected the guid node to exist" if node.nil?

      guid = RSS::Guid.from_xml(node)

      guid.is_perma_link.should eq false
      guid.content.should eq "http://dallas.example.com/1983/05/06/joebob.htm"
    end

    it "handles missing parameters" do
      node = XML.parse("<guid></guid>").first_element_child
      raise "Expected the guid node to exist" if node.nil?

      guid = RSS::Guid.from_xml(node)

      guid.is_perma_link.should eq false
      guid.content.should eq ""
    end
  end
end
