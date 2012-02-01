module SearchLogger
  class GoogleParser
    attr_accessor :query, :result, :position_offset

    def initialize(result = false)
      @result = result if result
      @position_offset = 0
      @base_url = "https://www.google.com/search?"
    end

    def query(query)
      self.tap { |s| s.query = query }
    end

    def search
      require "nokogiri"
      doc = Nokogiri::HTML.parse get_result

      doc.css('li.g').each_with_object([]) do |e, all|
        next unless e[:id].nil? || e[:id] =~ /mbb/

        title = e.at_css('h3 a').content unless e.at_css('h3 a').nil?
        url = e.at_css('h3 a')[:href] unless e.at_css('h3 a').nil?
        description = e.at_css('span.st').content unless e.at_css('span.st').nil?
        all << Result.new(
          id: e[:id].to_s,
          title: title,
          url: url,
          description: description
        )
      end
    end

    class Result
      attr_accessor :id, :title, :url, :description, :position

      def initialize(options)
        @id           = options[:id]
        @title        = options[:title]
        @url          = options[:url]
        @description  = options[:description]
      end
    end

    private

    def get_result
      return @result if @result
      url = @base_url
      query_strings = []
      query_strings << "q=#{@query}" if @query
      query_strings << "num=100"
      query_strings << "hl=en"
      query_strings << "start=#{@position_offset}" if @position_offset > 0
      url += query_strings.join("&")
      require 'httpclient'
      clnt = HTTPClient.new.get_content(url)
    end
  end
end