module SearchLogger
  class XmlParser
    attr_reader :file

    def initialize(xml_file)
      @file = File.open(xml_file)      
    end

    def parse(path = 'keywords keyword')
      require "nokogiri"
      doc = Nokogiri::XML @file
      doc.css(path).each_with_object([]) { |e, all| all << e.content }
    end
  end
end