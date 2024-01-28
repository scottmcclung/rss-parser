require "./spec_helper"
require "../src/rss/models/image"

describe RSS::Image do
  describe ".from_xml" do
    context "with all elements present" do
      it "parses the link correctly" do
        Examples.valid_image.link.should eq "http://example.com"
      end

      it "parses the title correctly" do
        Examples.valid_image.title.should eq "Example Title"
      end

      it "parses the url correctly" do
        Examples.valid_image.url.should eq "http://example.com/image.jpg"
      end

      it "parses the description correctly" do
        Examples.valid_image.description.should eq "Example Description"
      end

      it "parses the height correctly" do
        Examples.valid_image.height.should eq 32
      end

      it "parses the width correctly" do
        Examples.valid_image.width.should eq 96
      end
    end

    context "with missing optional elements" do
      it "handles missing description" do
        Examples.valid_image_missing_elements.description.should be_empty
      end

      it "handles missing title" do
        Examples.valid_image_missing_elements.title.should be_empty
      end

      it "handles missing link" do
        Examples.valid_image_missing_elements.link.should be_empty
      end

      it "handles missing url" do
        Examples.valid_image_missing_elements.url.should be_empty
      end

      it "uses default height" do
        Examples.valid_image_missing_elements.height.should eq 31
      end

      it "uses default width" do
        Examples.valid_image_missing_elements.width.should eq 88
      end
    end
  end
end

class Examples
  def self.valid_image
    xml_content = <<-XML
          <image>
            <link>http://example.com</link>
            <title>Example Title</title>
            <url>http://example.com/image.jpg</url>
            <description>Example Description</description>
            <height>32</height>
            <width>96</width>
          </image>
        XML

    node = XML.parse(xml_content).first_element_child
    raise "Expected the image node to exist" if node.nil?
    RSS::Image.from_xml(node)
  end

  def self.valid_image_missing_elements
    xml_content = <<-XML
    <image>
    </image>
  XML
    node = XML.parse(xml_content).first_element_child
    raise "Expected the image node to exist" if node.nil?
    RSS::Image.from_xml(node)
  end
end
