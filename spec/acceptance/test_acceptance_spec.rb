require "spec_helper"

describe "Test" do
  def load_xml
    xml_parser = SearchLogger::XmlParser.new('spec/support/file_repository/rankabove_test.xml')
    xml_parser.parse
  end

  def search_google(query_string)
    page_one = SearchLogger::GoogleParser.new.query(query_string).per_page(2).page(1).search
    page_two = SearchLogger::GoogleParser.new.query(query_string).per_page(2).page(2).last_result(page_one).search
    results = []
    position = 1
    (page_one + page_two).each do |e|
      e.position.should == position
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
    
  end

  it "load XML, search Google, save into MySQL and export CSV file" do
    xml = load_xml
    xml.should have(5).items
    xml.each do |value|
      google_results = search_google(value)
      google_results.should be_kind_of Array
      save_into_mysql(google_results)
    end
    #export_to_csv_file
  end
end