require "./spec_helper"
require "../src/rss/models/source"

describe RSS::Source do
  describe ".from_xml" do
    it "parses source with domain" do
      node = XML.parse("<source url=\"http://la.example.com/rss.xml\">Los Angeles Herald-Examiner</source>").first_element_child
      raise "Expected the source node to exist" if node.nil?

      source = RSS::Source.from_xml(node)

      source.url.should eq "http://la.example.com/rss.xml"
      source.content.should eq "Los Angeles Herald-Examiner"
    end

    it "parses source without url" do
      node = XML.parse("<source>Los Angeles Herald-Examiner</source>").first_element_child
      raise "Expected the source node to exist" if node.nil?

      source = RSS::Source.from_xml(node)

      source.url.should eq ""
      source.content.should eq "Los Angeles Herald-Examiner"
    end

    it "handles missing parameters" do
      node = XML.parse("<source></source>").first_element_child
      raise "Expected the source node to exist" if node.nil?

      source = RSS::Source.from_xml(node)

      source.url.should eq ""
      source.content.should eq ""
    end
  end
end
