require "search_logger"

module SearchLogger
  class Exec
    attr_accessor :command
    attr_reader :argv
    
    def initialize argv
      @argv = argv
      unless valid_argv?
        puts "Please, specify a file"
        exit
      end
      unless valid_file?
        puts "The file you specified is invalid"
        exit
      end
    end

    def valid_argv?
      @argv.length > 0
    end

    def valid_file?
      File.exists? @argv[0]
    end
    
    def run
      puts "1) Parsing the XML file"
      xml = load_xml

      puts "2) Searching Google and saving to MySQL (first 2 pages, 100 results each)"
      xml.each do |value|
        puts "Keyword: #{value.to_s}"

        print "\s\sGoogle: "
        google_results = search_google(value)
        print "\e[0;32mdone.\e[0m "

        print "\s\sMySQL: "
        save_into_mysql(google_results)
        print "\e[0;32mdone.\e[0m\n"
      end
      
      puts ""
      export_to_csv_file
      
      puts "\nCongratulations! Everything worked as expected. Please audit the CSV file to guarantee the quality of the data."
    end

    def load_xml
      xml_parser = SearchLogger::XmlParser.new(@argv.first).parse
    end

    def search_google(query_string)
      source = File.open('spec/support/file_repository/google_result_2.html').read
      #page_one = SearchLogger::GoogleParser.new.query(query_string).per_page(100).page(1).search
      #page_two = SearchLogger::GoogleParser.new.query(query_string).per_page(100).page(2).last_result(page_one).search
      page_one = SearchLogger::GoogleParser.new(source).search
      page_two = SearchLogger::GoogleParser.new(source).last_result(page_one).search
      results = []
      position = 1
      (page_one + page_two).each do |e|
        results << e.as_ary
        position += 1
      end
      results
    end

    def save_into_mysql(google_results)
      persistence = SearchLogger::Persistence.new
      persistence.data(google_results).table('google_results').save
    end

    def export_to_csv_file
      csv_path = ENV["HOME"] + "/search_logger.csv"
      csv_file = File.open(csv_path, "wb")
      
      print "3) Loading data from MySQL google_results table... "
      data = SearchLogger::Persistence.new.table("google_results").load_data
      print "\e[0;32mdone.\n\e[0m"

      print "4) Creating CSV file and adding data in #{csv_path}..."
      File.delete csv_path if File.exists? csv_path
      CSVExporter.new.export data, to: csv_file
      print "\e[0;32mdone.\n\e[0m"
    end
  end
end