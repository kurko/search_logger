module SearchLogger
  class GoogleParser
    attr_accessor :query, :result, :position_offset, :start, :num, :rough_query

    def initialize(result = false)
      @result = result if result
      @start, @position_offset = 0, 1
      @rough_query, @query = "", ""
      @num = 100
      @base_url = "https://www.google.com/search?"
    end

    # query options

    def query(query)
      self.tap { |s| s.query = query.gsub(/\s/, "+"); s.rough_query = query }
    end

    def per_page(quantity)
      self.tap { |s| s.num = quantity}
    end

    def page(current_page)
      self.tap { |s| s.start = ((current_page-1) * (s.num)); s.position_offset = s.start+1 }
    end

    def last_result(result)
      self.tap { |s| s.position_offset = result.last.position + 1 }
    end

    def search(result_object = Result)
      require "nokogiri"
      Nokogiri::HTML.parse(get_response).css('li.g').each_with_object([]) do |e, all|
        all << result_object.new(e, @position_offset, @rough_query).parse
        @position_offset += 1 unless all.empty?
      end
    end

    def url
      url = @base_url
      query_strings = []
      query_strings << "q=#{@query}" if @query
      query_strings << "num=#{num}"
      query_strings << "hl=en"
      query_strings << "start=#{@start}"
      url += query_strings.join("&")
      require "uri"
      url = URI.encode(url)
    end

    private

    def get_response
      return @result if @result
      require 'httpclient'
      clnt = HTTPClient.new.get(url, :follow_redirect => true).body
    end    
  end
end