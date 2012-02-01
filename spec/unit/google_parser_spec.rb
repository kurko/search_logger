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
      subject.search.size.should == 39
    end

    describe "results" do
      context "item 1" do 
        subject { SearchLogger::GoogleParser.new(result_double).search[0] }

        its(:title)       { should == "Amazon.com: Online Shopping for Electronics, Apparel, Computers ..." }
        its(:url)         { should == "http://www.amazon.com/" }
        its(:description) { should == "Online retailer of books, movies, music and games along with electronics, toys, apparel, sports, tools, groceries and general home and garden items. Region 1 ..." }
        pending "position"
      end

      context "item 7" do
        subject { SearchLogger::GoogleParser.new(result_double).search[7] }

        its(:title)       { should == "Kindle Fire - Full Color 7\" Multi-Touch Display with Wi ... - Amazon.com" }
        its(:url)         { should == "http://www.amazon.com/Kindle-Fire-Amazon-Tablet/dp/B0051VVOB2" }
        its(:description) { should == "The new Kindle Fire for only $199 is more than a tablet - it's a Kindle with a color touchscreen for web, movies, music, apps, games, reading & more." }
      end

      context "item 17" do
        subject { SearchLogger::GoogleParser.new(result_double).search[17] }

        its(:title)       { should == "Amazon.com - Wikipedia, the free encyclopedia" }
        its(:url)         { should == "http://en.wikipedia.org/wiki/Amazon.com" }
        its(:description) { should == "Amazon.com, Inc. (NASDAQ: AMZN) is an American multinational electronic commerce company with headquarters in Seattle, Washington, United States." }
      end

    end
  end
end