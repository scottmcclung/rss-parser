# The category element identifies a category or tag to which the feed belongs.
# A channel MAY contain more than one category element.
# The category's value SHOULD be a slash-delimited string that identifies a
# hierarchical position in the taxonomy.
#
# This element MAY include a domain attribute that identifies the taxonomy in which
# the category is placed.
#
# Example
# ```xml
#   <category domain="dmoz">News/Newspapers/Regional/United_States/Texas</category>
# ```
#

require "./model"

module RSS
  struct Category < Model
    getter domain : String?
    getter content : String

    private def initialize(@domain, @content); end

    def self.from_xml(node : XML::Node) : Category
      domain = node["domain"]?
      content = node.content || ""

      new(domain: domain, content: content)
    end
  end
end
