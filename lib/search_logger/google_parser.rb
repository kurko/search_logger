module SearchLogger
  class GoogleParser
    attr_accessor :query, :result, :position_offset, :num

    def initialize(result = false)
      @result = result if result
      @position_offset = 1
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

    def search(result_object = Result)
      require "nokogiri"
      Nokogiri::HTML.parse(get_response).css('li.g').each_with_object([]) do |e, all|
        all << result_object.new(e, @position_offset).parse
        @position_offset += 1
      end
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
  end
end