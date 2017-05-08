module RSpecApib
  module Extractor
    class Resource
      def self.call(document)
        collector = []
        find_nodes_within(document, collector: collector)
        collector
      end

      private

      def self.find_nodes_within(node, collector:)
        return node.each { |node| find_nodes_within(node, collector: collector)} if node.is_a?(Array)
        return unless node.is_a?(Hash)
        if node["element"] == "resource"
          collector << node
        elsif node.key?("content")
          find_nodes_within(node["content"], collector: collector)
        end
      end
    end
  end
end
