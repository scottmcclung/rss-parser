# The textInput element defines a form to submit a text query to the feed's publisher
# over the Common Gateway Interface (CGI).
# The element MUST contain a description, link, name and title child element.
#
# The RSS specification actively discourages publishers from using the textInput element,
# calling its purpose "something of a mystery" and stating that "most aggregators ignore it."
#
# TextInput elements:
#
#   - description: Holds character data that provides a human-readable label explaining the form's purpose (REQUIRED).
#   - link: Identifies the URL of the CGI script that handles the query (REQUIRED).
#   - name: Provides the name of the form component that contains the query (REQUIRED).
#   - title: Labels the button used to submit the query (REQUIRED).
#
# Example
# ```xml
# <textInput>
#   <description>Your aggregator supports the textInput element. What software are you using?</description>
#   <link>http://www.cadenhead.org/textinput.php</link>
#   <name>query</name>
#   <title>TextInput Inquiry</title>
# </textInput>
# ```
#

require "./model"

module RSS
  struct TextInput < Model
    getter description : String
    getter link : String
    getter name : String
    getter title : String

    private def initialize(@description, @link, @name, @title); end

    def self.from_xml(node : XML::Node) : TextInput
      description = content_from_xpath("description", node) || ""
      link = content_from_xpath("link", node) || ""
      name = content_from_xpath("name", node) || ""
      title = content_from_xpath("title", node) || ""

      new(description: description, link: link, name: name, title: title)
    end
  end
end
