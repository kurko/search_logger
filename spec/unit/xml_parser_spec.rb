# encoding: utf-8
require "spec_helper"

describe "XML parser" do
  let(:xml_file) { 'spec/support/file_repository/rankabove_test.xml' }

  subject { @parser = SearchLogger::XmlParser.new(xml_file) }

  it "#new" do
    subject.file.size.should == File.open(xml_file).size
  end

  context "#parse" do
    it "without argument" do
      subject.parse.should == ['seo software', 'ipad', 'muffuletta manhattanization', 'cheap motels', 'שפות תכנות']
    end

    it "with argument" do
      subject.parse('keywords keyword').should == ['seo software', 'ipad', 'muffuletta manhattanization', 'cheap motels', 'שפות תכנות']
    end
  end
end