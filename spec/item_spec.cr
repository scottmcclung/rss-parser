require "./spec_helper"
require "../src/rss/models/item"

describe RSS::Item do
  describe ".from_xml" do
    context "with all elements present" do
      it "parses the title correctly" do
        Examples.valid_item.title.should eq "Example Title"
      end

      it "parses the link correctly" do
        Examples.valid_item.link.should eq "http://example.com"
      end

      it "parses the description correctly" do
        Examples.valid_item.description.should eq "Example Description"
      end

      it "parses the author correctly" do
        Examples.valid_item.author.should eq "Example Author"
      end

      it "parses the publication_date correctly" do
        Examples.valid_item.publication_date.should be_a Time
      end

      it "parses the guid correctly" do
        # Examples.valid_item.guid.should eq "12345"
        guid = Examples.valid_item.guid
        guid.should_not be_nil
        guid.should be_a RSS::Guid
        guid.try &.content.should eq "12345"
      end

      it "parses multiple categories correctly" do
        Examples.valid_item.categories.size.should eq 2
        Examples.valid_item.categories[0].should be_a RSS::Category
        Examples.valid_item.categories[1].should be_a RSS::Category
      end

      it "parses the enclosure correctly" do
        Examples.valid_item.enclosure.should be_a RSS::Enclosure
      end
    end

    context "with missing optional elements" do
      it "handles missing author" do
        Examples.valid_item_missing_elements.author.should be_empty
      end

      it "handles missing publication_date" do
        Examples.valid_item_missing_elements.publication_date.should be_nil
      end

      it "handles missing guid" do
        Examples.valid_item_missing_elements.guid.should be_nil
      end

      it "handles missing categories" do
        Examples.valid_item_missing_elements.categories.should be_empty
      end

      it "handles missing enclosure" do
        Examples.valid_item_missing_elements.enclosure.should be_nil
      end
    end
  end
end

class Examples
  def self.valid_item
    xml_content = <<-XML
    <item>
      <title>Example Title</title>
      <link>http://example.com</link>
      <description>Example Description</description>
      <author>Example Author</author>
      <pubDate>Mon, 25 Jan 2024 16:00:00 +0000</pubDate>
      <guid>12345</guid>
      <category>News</category>
      <category>Technology</category>
      <enclosure url="http://example.com/media.mp3" length="12345" type="audio/mpeg"/>
    </item>
  XML
    node = XML.parse(xml_content).first_element_child
    raise "Expected the item node to exist" if node.nil?
    RSS::Item.from_xml(node)
  end

  def self.valid_item_missing_elements
    xml_content = <<-XML
    <item>
      <title>Example Title</title>
      <link>http://example.com</link>
      <description>Example Description</description>
    </item>
  XML
    node = XML.parse(xml_content).first_element_child
    raise "Expected the item node to exist" if node.nil?
    RSS::Item.from_xml(node)
  end
end
