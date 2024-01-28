require "./spec_helper"
require "../src/rss/models/cloud"

describe RSS::Cloud do
  describe ".from_xml" do
    it "parses cloud node with all attributes" do
      node = XML.parse("<cloud domain='example' path='/rpc' port='80' protocol='xml-rpc' registerProcedure='notify' />").first_element_child
      raise "Expected the cloud node to exist" if node.nil?

      cloud = RSS::Cloud.from_xml(node)

      cloud.domain.should eq "example"
      cloud.path.should eq "/rpc"
      cloud.port.should eq "80"
      cloud.protocol.should eq "xml-rpc"
      cloud.register_procedure.should eq "notify"
    end

    it "parses missing optional attributes" do
      node = XML.parse("<cloud domain='example' />").first_element_child
      raise "Expected the cloud node to exist" if node.nil?

      cloud = RSS::Cloud.from_xml(node)

      cloud.domain.should eq "example"
      cloud.path.should eq ""
      cloud.port.should eq ""
      cloud.protocol.should eq ""
      cloud.register_procedure.should eq ""
    end
  end
end
