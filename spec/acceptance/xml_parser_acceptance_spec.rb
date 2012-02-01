# encoding: utf-8
require "spec_helper"

describe "XML parser" do
  subject { SearchLogger::XmlParser.new('spec/support/file_repository/rankabove_test.xml') }

  it "loads a XML file and extracts its keywords into an array" do
    subject.parse.should == ['seo software', 'ipad', 'muffuletta manhattanization', 'cheap motels', 'שפות תכנות']
  end
end