require "./spec_helper"
require "../src/rss/models/category"

describe RSS::Category do
  describe ".from_xml" do
    it "parses category with domain" do
      node = XML.parse("<category domain='dmoz'>News</category>").first_element_child
      raise "Expected the category node to exist" if node.nil?

      category = RSS::Category.from_xml(node)

      category.domain.should_not be_nil
      category.domain.should eq "dmoz"
      category.content.should eq "News"
    end

    it "parses category without domain" do
      node = XML.parse("<category>Tech</category>").first_element_child
      raise "Expected the category node to exist" if node.nil?

      category = RSS::Category.from_xml(node)

      category.domain.should be_nil
      category.content.should eq "Tech"
    end

    it "handles missing parameters" do
      node = XML.parse("<category></category>").first_element_child
      raise "Expected the category node to exist" if node.nil?

      category = RSS::Category.from_xml(node)

      category.domain.should be_nil
      category.content.should eq ""
    end
  end
end
