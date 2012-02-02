require "spec_helper"

describe "Google parser" do
  let(:result_double) { File.open('spec/support/file_repository/google_result.html').read }
  subject { SearchLogger::GoogleParser.new(result_double) }

  it "initialization with a double" do
    subject.result.size.should == result_double.size
  end

  describe "#search" do
    it "is an array" do
      subject.search.should be_kind_of Array
    end

    it "has two results" do
      subject.search.size.should == 41
    end
  end

  describe "#get_result_elements" do
    context "normal result" do
      before do
        @node = Nokogiri::HTML.parse(result_double).css('li.g').first
      end

      subject { SearchLogger::GoogleParser::Result.new @node }

      its(:title)       { should == "Amazon.com: Online Shopping for Electronics, Apparel, Computers ..." }
      its(:url)         { should == "http://www.amazon.com/" }
      its(:description) { should == "Online retailer of books, movies, music and games along with electronics, toys, apparel, sports, tools, groceries and general home and garden items. Region 1 ..." }
    end

    context "newsbox" do
      before do
        @node = Nokogiri::HTML.parse(result_double).css('li#newsbox').first
      end
      
      subject { SearchLogger::GoogleParser::Result.new @node }

      its(:title)       { should == "Amazon fourth quarter profit falls on heavy expenses" }
      its(:url)         { should == "http://www.usatoday.com/tech/news/story/2012-01-31/amazon-earnings/52907866/1" }
      its(:description) { should == "By Roger Yu, USA TODAY Despite rising sales, Amazon, the largest Internet retailer, reported a 57% decline in its fourth-quarter profit due to heavy ..." }
    end
  end
end