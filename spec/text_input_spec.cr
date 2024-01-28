require "./spec_helper"
require "../src/rss/models/text_input"

describe RSS::TextInput do
  describe ".from_xml" do
    it "parses text input with all elements" do
      node = XML.parse(
        "<textInput>
          <description>Description</description>
          <link>http://example.com</link>
          <name>name</name>
          <title>Title</title>
        </textInput>"
      ).first_element_child
      raise "Expected the text input node to exist" if node.nil?

      text_input = RSS::TextInput.from_xml(node)

      text_input.description.should eq "Description"
      text_input.link.should eq "http://example.com"
      text_input.name.should eq "name"
      text_input.title.should eq "Title"
    end

    it "handles missing description element" do
      node = XML.parse("<textInput></textInput>").first_element_child
      raise "Expected the text input node to exist" if node.nil?

      text_input = RSS::TextInput.from_xml(node)

      text_input.description.should eq ""
      text_input.link.should eq ""
      text_input.name.should eq ""
      text_input.title.should eq ""
    end
  end
end
