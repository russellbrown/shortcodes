require 'active_support/core_ext/class/attribute'

module Shortcodes
  class Parser
    autoload 'Nokogiri', 'nokogiri'
    autoload 'Sanitize', 'sanitize'

    class_attribute :handlers
    class_attribute :default_handler
    self.handlers ||= {}

    attr_reader :content

    def initialize(content)
      @content = content
    end

    Shortcode = Struct.new(:code, :attributes)

    def to_html
      content.gsub(/\[[^\]]+\]/) do |code|
        shortcode = parse_shortcode(code)

        get_handler(shortcode).call shortcode
      end
    end

    private

    def parse_attributes(node)
      Hash[node.to_a]
    end

    def get_handler(shortcode)
      handlers.fetch(shortcode.code) { default_handler }
    end

    def parse_shortcode(code)
      code = Sanitize.clean(code).gsub(/^\[/, '<').gsub(/\]$/, '>')
      doc = Nokogiri::XML.parse(code)
      node = doc.root

      Shortcode.new(node.name, parse_attributes(node))
    end

  end
end
