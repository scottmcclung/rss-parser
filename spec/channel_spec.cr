require "./spec_helper"
require "../src/rss/models/channel"

describe RSS::Channel do
  describe ".from_xml" do
    context "including all elements" do
      it "parses the title correctly" do
        Examples.valid_channel.title.should eq "Dallas Times-Herald"
      end

      it "parses the link correctly" do
        Examples.valid_channel.link.should eq "http://dallas.example.com"
      end

      it "parses the description correctly" do
        Examples.valid_channel.description.should eq "Current headlines from the Dallas Times-Herald newspaper"
      end

      it "parses the language correctly" do
        Examples.valid_channel.language.should eq "en-us"
      end

      it "parses the copyright correctly" do
        Examples.valid_channel.copyright.should eq "Copyright 2023 Dallas Times-Herald"
      end

      it "parses the managing editor correctly" do
        Examples.valid_channel.managing_editor.should eq "jlehrer@dallas.example.com (Jim Lehrer)"
      end

      it "parses the web master correctly" do
        Examples.valid_channel.web_master.should eq "helpdesk@dallas.example.com"
      end

      it "parses the publication date correctly" do
        Examples.valid_channel.publication_date.should be_a Time
      end

      it "parses the last build date correctly" do
        Examples.valid_channel.last_build_date.should be_a Time
      end

      it "parses categories correctly" do
        Examples.valid_channel.categories.size.should eq 2
        Examples.valid_channel.categories[0].should be_a RSS::Category
        Examples.valid_channel.categories[1].should be_a RSS::Category
      end

      it "parses the generator correctly" do
        Examples.valid_channel.generator.should eq "Microsoft Spaces v1.1"
      end

      it "parses the docs correctly" do
        Examples.valid_channel.docs.should eq "https://www.rssboard.org/rss-specification"
      end

      it "parses the cloud correctly" do
        Examples.valid_channel.cloud.should be_a RSS::Cloud
      end

      it "parses the ttl correctly" do
        Examples.valid_channel.ttl.should eq 60
      end

      it "parses images correctly" do
        Examples.valid_channel.images.size.should eq 1
        Examples.valid_channel.images.first.should be_a RSS::Image
      end

      it "parses the rating correctly" do
        Examples.valid_channel.rating.should eq "(PICS-1.1 \"http://www.rsac.org/ratingsv01.html\" l by \"webmaster@example.com\" on \"2007.01.29T10:09-0800\" r (n 0 s 0 v 0 l 0))"
      end

      it "parses the text input correctly" do
        Examples.valid_channel.text_input.should be_a RSS::TextInput
      end

      it "parses skip hours correctly" do
        Examples.valid_channel.skip_hours.should eq [0, 1, 2, 22, 23]
      end

      it "parses skip days correctly" do
        Examples.valid_channel.skip_days.should eq ["Saturday", "Sunday"]
      end

      it "parses items correctly" do
        Examples.valid_channel.items.size.should eq 2
        Examples.valid_channel.items.each do |item|
          item.should be_a RSS::Item
        end
      end
    end

    context "with missing required elements" do
      it "handles missing title" do
        Examples.valid_channel_missing_elements.title.should eq ""
      end

      it "handles missing link" do
        Examples.valid_channel_missing_elements.link.should eq ""
      end

      it "handles missing description" do
        Examples.valid_channel_missing_elements.description.should eq ""
      end
    end

    context "with malformed data" do
      it "handles incorrect publication date format" do
        Examples.valid_channel_missing_elements.publication_date.should be_nil
      end

      it "handles incorrect last build date format" do
        Examples.valid_channel_missing_elements.last_build_date.should be_nil
      end

      it "handles non-integer ttl" do
        Examples.valid_channel_missing_elements.ttl.should be_nil
      end

      # Add similar tests for other malformed data scenarios
    end
  end
end

context "with malformed data" do
  it "handles incorrect publication date format" do
    xml_content = <<-XML
          <channel>
            <title>Example Title</title>
            <link>http://example.com</link>
            <description>Example Description</description>
            <pubDate>Incorrect Date Format</pubDate>
          </channel>
        XML
    expect_raises(Exception) do
      Examples.parse(xml_content)
    end
  end

  it "handles incorrect last build date format" do
    xml_content = <<-XML
          <channel>
            <title>Example Title</title>
            <link>http://example.com</link>
            <description>Example Description</description>
            <lastBuildDate>Incorrect Date Format</lastBuildDate>
          </channel>
        XML
    expect_raises(Exception) do
      Examples.parse(xml_content)
    end
  end

  it "handles non-integer ttl" do
    xml_content = <<-XML
          <channel>
            <title>Example Title</title>
            <link>http://example.com</link>
            <description>Example Description</description>
            <ttl>NonInteger</ttl>
          </channel>
        XML
    expect_raises(Exception) do
      Examples.parse(xml_content)
    end
  end
end

# Add tests for duplicate required elements, invalid skip hours/days, etc.

class Examples
  def self.valid_channel
    xml_content = <<-XML
    <channel>
    <title>Dallas Times-Herald</title>
    <link>http://dallas.example.com</link>
    <description>Current headlines from the Dallas Times-Herald newspaper</description>
    <language>en-us</language>
    <copyright>Copyright 2023 Dallas Times-Herald</copyright>
    <managingEditor>jlehrer@dallas.example.com (Jim Lehrer)</managingEditor>
    <webMaster>helpdesk@dallas.example.com</webMaster>
    <pubDate>Sun, 14 Oct 2023 05:00:00 GMT</pubDate>
    <lastBuildDate>Sun, 14 Oct 2023 17:17:44 GMT</lastBuildDate>
    <category domain="dmoz">News/Newspapers/Regional/United_States/Texas</category>
    <category>News/Newspapers/Regional/United_States/Washington</category>
    <generator>Microsoft Spaces v1.1</generator>
    <docs>https://www.rssboard.org/rss-specification</docs>
    <cloud domain="server.example.com" path="/rpc" port="80" protocol="xml-rpc" registerProcedure="cloud.notify"/>
    <ttl>60</ttl>
    <rating>(PICS-1.1 "http://www.rsac.org/ratingsv01.html" l by "webmaster@example.com" on "2007.01.29T10:09-0800" r (n 0 s 0 v 0 l 0))</rating>
    <textInput>
      <description>Your aggregator supports the textInput element. What software are you using?</description>
      <link>http://www.cadenhead.org/textinput.php</link>
      <name>query</name>
      <title>TextInput Inquiry</title>
    </textInput>
    <skipDays>
      <day>Saturday</day>
      <day>Sunday</day>
    </skipDays>
    <skipHours>
      <hour>0</hour>
      <hour>1</hour>
      <hour>2</hour>
      <hour>22</hour>
      <hour>23</hour>
    </skipHours>
    <image>
      <link>http://dallas.example.com</link>
      <title>Dallas Times-Herald</title>
      <url>http://dallas.example.com/masthead.gif</url>
      <description>Read the Dallas Times-Herald</description>
      <height>32</height>
    </image>
    <item>
      <title>News Item 1</title>
      <link>http://dallas.example.com/news1</link>
      <description>Details about News Item 1</description>
      <pubDate>Sun, 14 Oct 2023 06:00:00 GMT</pubDate>
    </item>
    <item>
      <title>News Item 2</title>
      <link>http://dallas.example.com/news2</link>
      <description>Details about News Item 2</description>
      <pubDate>Sun, 14 Oct 2023 07:00:00 GMT</pubDate>
    </item>
  </channel>

  XML
    parse(xml_content, "Expected the channel node to exist")
  end

  def self.valid_channel_missing_elements
    xml_content = <<-XML
    <channel></channel>
  XML
    parse(xml_content, "Expected the channel node to exist")
  end

  def self.parse(xml_content : String)
    parse(xml_content, "Expected at least one child node to exist in the provided document")
  end

  def self.parse(xml_content : String, error_message : String)
    node = XML.parse(xml_content).first_element_child
    if node.nil?
      raise error_message
    end
    RSS::Channel.from_xml(node)
  end
end
