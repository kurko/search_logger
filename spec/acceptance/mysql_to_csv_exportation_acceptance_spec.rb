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
    saved_data[0].join(',').should == 'keyword,position,url,title,description'
    saved_data[1].join(',').should == 'amazon,1,www.github.com,This is a title,First description.'
    saved_data[2].join(',').should == 'שפות תכנות,2,www.github.com,שפות תכנות,שפות, תכנות.'
    saved_data[3].join(',').should == 'amazon,3,www.github.com,This is the, third title,Third description.'
  end
end