require "spec_helper"

describe "Google parser" do
  let(:result_double) { File.open('spec/support/file_repository/google_result_2.html').read }
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
    subject { SearchLogger::GoogleParser.new }

    it "set the current page" do
      subject.per_page(5).page(1).position_offset.should == 1
      subject.per_page(5).page(1).start.should == 0
      subject.per_page(5).page(2).position_offset.should == 6
      subject.per_page(5).page(2).start.should == 5
      subject.per_page(5).page(3).position_offset.should == 11
      subject.per_page(5).page(3).start.should == 10
    end
  end

  describe "#url" do
    subject { SearchLogger::GoogleParser.new }

    it "creates the correct url" do
      subject.query('amazon website').per_page(5).page(1)
      subject.url.should == "https://www.google.com/search?q=amazon+website&num=5&hl=en&start=0"
    end

    it "creates the correct url" do
      subject.query('amazon website').per_page(5).page(2)
      subject.url.should == "https://www.google.com/search?q=amazon+website&num=5&hl=en&start=5"
    end

    it "creates the correct url" do
      subject.query('amazon website').per_page(5).page(3)
      subject.url.should == "https://www.google.com/search?q=amazon+website&num=5&hl=en&start=10"
    end
  end

  describe "#search" do
    it "calls Result correctly" do
      result_object = double("Result", parse: nil)
      result_object.stub(:new).with(anything, an_instance_of(Fixnum), an_instance_of(String)).and_return(result_object)
      result_object.should_receive(:parse)
      subject.search(result_object)
    end

    it "is an array" do
      subject.search.should be_kind_of Array
    end

    it "returns Result object" do
      subject.search.first.should be_kind_of SearchLogger::GoogleParser::Result
    end

    it "has 100 results" do
      subject.search.size.should == 100
    end
  end
end