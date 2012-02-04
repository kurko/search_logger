require "spec_helper"

describe "Google parser" do
  let(:result_double) { File.open('spec/support/file_repository/google_result.html').read }
  subject { SearchLogger::GoogleParser.new(result_double) }

  it "initialization with a double" do
    subject.result.size.should == result_double.size
  end

  describe "#per_page" do
    it "set how many results per page there should be" do
      subject.per_page(20).num.should == 20
    end
  end

  describe "#page" do
    it "set the current page" do
      subject.page(3).position_offset.should == 300
    end
  end

  describe "#url" do
    subject { SearchLogger::GoogleParser.new.query('amazon website').per_page(5).page(2) }

    it "creates the correct url" do
      subject.url.should == "https://www.google.com/search?q=amazon+website&num=5&hl=en&start=9"
    end
  end

  describe "#search" do
    it "is an array" do
      subject.search.should be_kind_of Array
    end

    it "returns Result object" do
      subject.search.first.should be_kind_of SearchLogger::GoogleParser::Result
    end

    it "has two results" do
      subject.search.size.should == 41
    end
  end
end