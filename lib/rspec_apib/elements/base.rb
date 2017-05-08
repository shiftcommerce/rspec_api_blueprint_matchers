# frozen_string_literal: true
module RSpecApib
  module Element
    BaseStruct = Struct.new(:element, :meta, :attributes, :content, :parent)

    # A base class for all objects in api-elements (http://api-elements.readthedocs.io/en/latest/)
    class Base < BaseStruct
      def inspect
        "##{self.class} (element: #{element}, meta: #{meta}, attributes: #{attributes.inspect}, content: #{content.inspect}, parent: ##{parent.class})"
      end

      def self.parse_root(root)
        index = {}
        result = parse(root, index: index, parent: nil)
        [result, index]
      end

      def self.parse(node_or_nodes, index:, parent:, klass: nil)
        return node_or_nodes.map { |node| parse(node, index: index, parent: parent) } if node_or_nodes.is_a?(::Array)
        return transformed_basic_hash(node_or_nodes, index: index, parent: parent) if basic_hash?(node_or_nodes)
        return node_or_nodes unless !klass.nil? || base_element?(node_or_nodes)
        hash = node_or_nodes
        klass_name = klass
        klass_name ||= hash["element"].slice(0, 1).capitalize + hash["element"].slice(1..-1).delete(" ")
        return node_or_nodes unless RSpecApib::Element.const_defined?(klass_name)
        klass = RSpecApib::Element.const_get(klass_name)
        index[klass] ||= []
        element = klass.from_hash(hash, index: index, parent: parent)
        index[klass] << element
        element
      end

      def self.from_hash(hash, index:, parent:)
        attrs = parse_attributes(hash["attributes"], index: index, parent: parent)
        child = new(hash["element"], hash["meta"], attrs, nil, parent)
        child.content = parse(hash["content"], index: index, parent: child)
        inherit_attrs_from_ancestors(child)
        child
      end

      def self.inherit_attrs_from_ancestors(child)
        child.attributes ||= {}
        attrs = child.attributes
        attrs_to_inherit.each do |attr|
          attr_as_str = attr.to_s
          unless attrs.key?(attr_as_str)
            val = ancestor_attr(child, attr_as_str)
            attrs[attr_as_str] = val unless val.nil?
          end
        end
      end

      def self.ancestor_attr(node, attr)
        return nil if node.nil?
        return node.attributes[attr] if node.attributes && node.attributes.key?(attr)
        ancestor_attr(node.parent, attr)
      end

      def self.attrs_to_inherit
        []
      end

      def self.attr_readers
        {}
      end

      def self.base_element?(node)
        node.is_a?(::Hash) && node.keys.include?("element")
      end

      def self.attributes_schema
        {}
      end

      def self.parse_attributes(node, index:, parent:)
        return node if node.nil?
        node = node.dup
        node.keys.each do |key|
          klass = attributes_schema[key.to_sym]
          node[key] = parse(node[key], index: index, parent: parent, klass: klass)
        end
        node
      end

      def self.basic_hash?(node)
        node.is_a?(::Hash) && !base_element?(node)
      end

      def self.transformed_basic_hash(node, index:, parent:)
        node = node.dup
        node.keys.each do |key|
          node[key] = parse(node[key], index: index, parent: parent)
        end
        node
      end
    end
  end
end
