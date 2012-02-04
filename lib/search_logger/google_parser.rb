module SearchLogger
  class GoogleParser
    attr_accessor :query, :result, :position_offset, :num

    def initialize(result = false)
      @result = result if result
      @position_offset = 0
      @num = 100
      @base_url = "https://www.google.com/search?"
    end

    # query options

    def query(query)
      self.tap { |s| s.query = query.gsub(/\s/, "+") }
    end

    def per_page(quantity)
      self.tap { |s| s.num = quantity}
    end

    def page(current_page)
      self.tap { |s| s.position_offset = current_page * s.num }
    end

    def search
      require "nokogiri"
      Nokogiri::HTML.parse(get_response).css('li.g').each_with_object([]) { |e, all| all << Result.new(e) }
    end

    def url
      url = @base_url
      query_strings = []
      query_strings << "q=#{@query}" if @query
      query_strings << "num=#{num}"
      query_strings << "hl=en"
      query_strings << "start=#{@position_offset-1}" if @position_offset > 0
      url += query_strings.join("&")
    end

    private

    def get_response
      return @result if @result
      require 'httpclient'
      clnt = HTTPClient.new.get_content(url)
    end    

    class Result
      attr_accessor :node, :title, :url, :description, :position

      def initialize(node = false)
        @node = node
        @title, @url, @description = nil, nil, nil
        parse_node
      end

      def parse_node
        set_result(parse_normal_result) if node[:id].nil? || node[:id] =~ /mbb/
        set_result(parse_news_result) if node[:id] == "newsbox"
      end

      def parse_normal_result
        result = {}.tap do |e|
          e[:title]       = sanitize_string node.at_css('h3 a').content     unless node.at_css('h3 a').nil?
          e[:url]         = sanitize_string node.at_css('h3 a')[:href]      unless node.at_css('h3 a').nil?
          e[:description] = sanitize_string node.at_css('span.st').content  unless node.at_css('span.st').nil?
        end
      end

      def parse_news_result
        result = {}.tap do |e|
          title_link      = node.at_css('li.w0 span.tl a')
          description     = node.at_css('li.w0 span[dir=ltr]')
          e[:title]       = sanitize_string title_link.content  unless title_link.nil?
          e[:url]         = sanitize_string title_link[:href]   unless title_link.nil?
          e[:description] = sanitize_string description.content unless description.nil?
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