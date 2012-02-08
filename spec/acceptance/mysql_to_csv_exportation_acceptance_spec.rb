# encoding: utf-8
require "spec_helper"

describe "Exporting MySQL data to a CSV file" do
  let(:data) {
    [
      { id: 726, searched_keyword: "amazon", title: "This is a title", 
        url: "www.github.com", description: "First description.",
        position: 1, created_at: nil },
      { id: 727, searched_keyword: "שפות תכנות", title: "שפות תכנות",
        url: "www.github.com", description: "שפות, תכנות.",
        position: 2, created_at: nil },
      { id: 728, searched_keyword: "amazon", title: "This is the, third title",
        url: "www.github.com", description: "Third description.",
        position: 3, created_at: nil }
    ]
  }
  let(:target_file) { File.expand_path("../../support/file_repository/exported_from_persistence.csv", __FILE__) }

  before do
    File.delete target_file if File.exists? target_file
  end

  it "if no data is sent, no data is saved" do
    CSVExporter.new.export [], to: target_file
  end

  it "saves data into a CSV file" do
    CSVExporter.new.export data, to: target_file
    File.exists?(target_file).should be_true
    saved_data = CSV.parse File.read(target_file)
    saved_data[0].join(',').should == 'id,searched_keyword,title,url,description,position,created_at'
    saved_data[1].join(',').should == '726,amazon,This is a title,www.github.com,First description.,1,'
    saved_data[2].join(',').should == '727,שפות תכנות,שפות תכנות,www.github.com,שפות, תכנות.,2,'
    saved_data[3].join(',').should == '728,amazon,This is the, third title,www.github.com,Third description.,3,'
  end

  pending "check if dir has write permission"
end