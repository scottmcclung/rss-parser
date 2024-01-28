# The cloud element indicates that updates to the feed can be monitored using a web service that
# implements the RssCloud application programming interface
#
# The element MUST have five attributes that describe the service:
#   - domain: Identifies the host name or IP address of the web service that monitors updates to the feed.
#   - path: Provides the web service's path.
#   - port: Identifies the web service's TCP port.
#   - protocol: MUST contain the value "xml-rpc" if the service employs XML-RPC or "soap" if it employs SOAP.
#   - register_procedure: Names the remote procedure to call when requesting notification of updates.
#
# Example
# ```xml
#   <cloud domain="server.example.com" path="/rpc" port="80" protocol="xml-rpc" registerProcedure="cloud.notify" />
# ```
#

require "./model"

module RSS
  struct Cloud < Model
    getter domain : String
    getter path : String
    getter port : String
    getter protocol : String
    getter register_procedure : String

    private def initialize(@domain, @path, @port, @protocol, @register_procedure); end

    def self.from_xml(node : XML::Node) : Cloud
      domain = node["domain"]? || ""
      path = node["path"]? || ""
      port = node["port"]? || ""
      protocol = node["protocol"]? || ""
      register_procedure = node["registerProcedure"]? || ""

      new(domain: domain, path: path, port: port, protocol: protocol, register_procedure: register_procedure)
    end
  end
end
