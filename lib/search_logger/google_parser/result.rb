module SearchLogger
  class GoogleParser
    class Result
      attr_accessor :title, :url, :description, :position, :searched_keyword

      def initialize(node, position, searched_keyword)
        raise "No HTML node was specified" if node == false
        @position, @searched_keyword = position, searched_keyword
        @title, @url, @description = nil
        @node = node
      end

      def parse
        parse_normal_result if @node[:id].nil? || @node[:id] =~ /mbb/
        parse_news_result   if @node[:id] == "newsbox"
        self
      end

      def as_ary
        { title:            title,
          url:              url,
          description:      description,
          position:         position,
          searched_keyword: searched_keyword
        }
      end

      def parse_normal_result
        self.tap do |e|
          e.title       = sanitize_string @node.at_css('h3 a').content  unless @node.at_css('h3 a').nil?
          e.url         = sanitize_string @node.at_css('h3 a')[:href]   unless @node.at_css('h3 a').nil?
          e.description = sanitize_string @node.at_css('div.s').content unless @node.at_css('div.s').nil?
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
        string.gsub(/&amp;/, "&")
              .gsub(/[\s]{1,99}/, " ")
              .strip
              .gsub(/\s\.\.\.[\s]{0,1}[w]{0,3}.*- Cached - Similar/, " ...")
      end

      def set_result(options = {})
        @title        = options[:title]
        @url          = options[:url]
        @description  = options[:description]
      end
    end
  end
end