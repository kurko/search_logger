require "spec_helper"

describe "Test" do
  def load_xml
    
  end

  def search_google(xml)
    
  end

  def save_into_mysql(google_results)
    
  end

  def export_to_csv_file
    
  end

  pending "load XML, search Google, save into MySQL and export CSV file" do
    xml = load_xml
    google_results = search_google(xml)
    save_into_mysql(google_results)
    export_to_csv_file
  end
end