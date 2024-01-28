module RSS
  abstract struct Model
    private def self.determine_default(node : XML::Node)
      # If there is a default namespace, return its prefix. Otherwise, return an empty string.
      namespaces = node.namespaces
      return "" if namespaces.nil? || !namespaces.has_key?("xmlns")
      "xmlns"
    end

    private def self.build_xpath(base_query : String, path_prefix : String) : String
      path_prefix.empty? ? base_query : "#{path_prefix}:#{base_query}"
    end

    def self.content_from_xpath(base_query : String, node : XML::Node) : String?
      xpath = build_xpath(base_query, determine_default(node))
      node.xpath_node(xpath).try &.content
    end

    def self.node_from_xpath(base_query : String, node : XML::Node) : XML::Node?
      xpath = build_xpath(base_query, determine_default(node))
      node.xpath_node(xpath)
    end

    def self.nodes_from_xpath(base_query : String, node : XML::Node) : XML::NodeSet
      xpath = build_xpath(base_query, determine_default(node))
      node.xpath_nodes(xpath)
    end
  end
end
