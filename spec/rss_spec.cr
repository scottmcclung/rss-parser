require "./spec_helper"
require "../src/rss"

private EXAMPLE_FEED = "./spec/fixtures/example.xml"

describe RSS do
  describe ".parse" do
    context "with a valid RSS feed" do
      it "parses the feed successfully" do
        xml_content = File.read(EXAMPLE_FEED)
        channel = RSS.parse(xml_content)
        channel.should be_a RSS::Channel
        channel.title.should eq "PV02"
        channel.link.should eq "https://www.pv02comic.com"
        channel.description.should eq "A robot named Pivot"
        channel.language.should eq "en-US"

        channel.images.size.should eq 1
        image = channel.images[0]
        image.title.should eq "PV02"
        image.url.should eq "https://www.pv02comic.com/wp-content/uploads/2020/12/cropped-pivot-icon2-32x32.png"
        image.link.should eq "https://www.pv02comic.com"
        image.width.should eq 32
        image.height.should eq 33

        channel.items.size.should eq 10
        item = channel.items[0]
        item.title.should eq "Pivot Plushie!?"
        item.publication_date.should eq Time.utc(2023, 9, 22, 18, 7, 42)
        item.categories.size.should eq 2
        item.categories[0].content.should eq "News"
        item.guid.should_not be_nil
        item.guid.should be_a RSS::Guid
        item.guid.try &.content.should eq "https://www.pv02comic.com/?p=2204"
        item.description.should eq "Hey ya'll, it's been a while. I come bearing a huge announcement: Pivot currently has a petition up on Makeship to produce a plushie! This is a preliminary petition, requiring $2 pledges, 200 in total over 7 days, in order to secure a full crowdfunding campaign at a later date. The pledges also count to your preorder at a later date if and when the full campaign launches. If you want to pledge, head over to Makeship! Apologies to those who were hoping this was an announcement of the comic's return, but I figured you all would be interested in this as well! I do want to revisit the comic some day, though it probably won't be in comic form. I've been working a lot on new concepts and overhauling the story to make it flow better and involve the themes I actually wanted. Can't really promise anything yet, though."
        item.comments.should eq "https://www.pv02comic.com/pivot-plushie/#comments"
        item.source.should_not be_nil
        item.source.should be_a RSS::Source
        item.source.try &.content.should eq "Los Angeles Herald-Examiner"
        item.source.try &.url.should eq "http://la.example.com/rss.xml"
      end
    end

    context "with missing rss root element" do
      it "raises RSSParsingError" do
        xml_content = <<-XML
          <notrss>
            <channel></channel>
          </notrss>
        XML
        expect_raises(RSS::RSSParsingError) do
          RSS.parse(xml_content)
        end
      end
    end

    context "with invalid document structure" do
      it "raises RSSParsingError for missing channel element" do
        xml_content = <<-XML
          <rss></rss>
        XML
        expect_raises(RSS::RSSParsingError) do
          RSS.parse(xml_content)
        end
      end

      it "raises RSSParsingError for incorrect root element" do
        xml_content = <<-XML
          <feed>
            <channel></channel>
          </feed>
        XML
        expect_raises(RSS::RSSParsingError) do
          RSS.parse(xml_content)
        end
      end
    end

    # Additional tests for other potential parsing errors or edge cases
  end
end
