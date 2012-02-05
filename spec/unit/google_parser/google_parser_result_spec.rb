require "spec_helper"

describe SearchLogger::GoogleParser::Result do
  let(:result_double) { File.open('spec/support/file_repository/google_result.html').read }

  describe "parsing a single result" do
    before do
      @node = Nokogiri::HTML.parse(result_double).css('li.g').first
    end

    subject { SearchLogger::GoogleParser::Result.new(@node, 10).parse_normal_result }

    its(:title)       { should == "Amazon.com: Online Shopping for Electronics, Apparel, Computers ..." }
    its(:url)         { should == "http://www.amazon.com/" }
    its(:description) { should == "Online retailer of books, movies, music and games along with electronics, toys, apparel, sports, tools, groceries and general home and garden items. Region 1 ..." }
    its(:position)    { should == 10 }
  end

  describe "#parse" do
    context "normal result" do
      before do
        @node = Nokogiri::HTML.parse(result_double).css('li.g').first
      end

      subject { SearchLogger::GoogleParser::Result.new(@node, 2).parse }

      its(:title)       { should == "Amazon.com: Online Shopping for Electronics, Apparel, Computers ..." }
      its(:url)         { should == "http://www.amazon.com/" }
      its(:description) { should == "Online retailer of books, movies, music and games along with electronics, toys, apparel, sports, tools, groceries and general home and garden items. Region 1 ..." }
      its(:position)    { should == 2 }
    end

    context "newsbox" do
      before do
        @node = Nokogiri::HTML.parse(result_double).css('li#newsbox').first
      end
      
      subject { SearchLogger::GoogleParser::Result.new(@node, 6).parse }

      its(:title)       { should == "Amazon fourth quarter profit falls on heavy expenses" }
      its(:url)         { should == "http://www.usatoday.com/tech/news/story/2012-01-31/amazon-earnings/52907866/1" }
      its(:description) { should == "By Roger Yu, USA TODAY Despite rising sales, Amazon, the largest Internet retailer, reported a 57% decline in its fourth-quarter profit due to heavy ..." }
      its(:position)    { should == 6 }
    end
  end
end