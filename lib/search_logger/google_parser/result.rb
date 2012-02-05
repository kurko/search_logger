module SearchLogger
  class GoogleParser
    class Result
      attr_accessor :title, :url, :description, :position

      def initialize(node, position)
        raise "No HTML node was specified" if node == false
        @position = position
        @title, @url, @description = nil
        @node = node
      end

      def parse
        parse_normal_result if @node[:id].nil? || @node[:id] =~ /mbb/
        parse_news_result   if @node[:id] == "newsbox"
        self
      end

      def parse_normal_result
        self.tap do |e|
          e.title       = sanitize_string @node.at_css('h3 a').content     unless @node.at_css('h3 a').nil?
          e.url         = sanitize_string @node.at_css('h3 a')[:href]      unless @node.at_css('h3 a').nil?
          e.description = sanitize_string @node.at_css('span.st').content  unless @node.at_css('span.st').nil?
        end
      end

      def parse_news_result
        self.tap do |e|
          title_link    = @node.at_css('li.w0 span.tl a')
          description   = @node.at_css('li.w0 span[dir=ltr]')
          e.title       = sanitize_string title_link.content  unless title_link.nil?
          e.url         = sanitize_string title_link[:href]   unless title_link.nil?
          e.description = sanitize_string description.content unless description.nil?
        end
      end

      def sanitize_string(string)
        string.gsub(/&amp;/, "&").strip
      end

      def set_result(options = {})
        @title        = options[:title]
        @url          = options[:url]
        @description  = options[:description]
      end
    end
  end
end