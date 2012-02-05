# encoding: utf-8
require "spec_helper"

describe "Google parser" do
  before :all do
    @response = SearchLogger::GoogleParser.new.query('amazon').per_page(5).search
  end

  it "searches for a keyword" do
    @response.should be_kind_of Array
  end

  it "searches with hebraic keywords" do
    @response = SearchLogger::GoogleParser.new.query('שפות תכנות').per_page(5).search
    @response.should have(5).items
  end

  # depending on the query string, Google returns more or less than 100 links
  it "returns around 100 results per page by default" do
    response = SearchLogger::GoogleParser.new.query('amazon').per_page(100).search
    response.should have_at_least(95).items
    response.should have_at_most(105).items
  end

  context "multiple pages" do
    before :all do
      @all_results = SearchLogger::GoogleParser.new.query('amazon').per_page(5).search.map { |e| e.title }
    end

    it "returns 2 results" do
      (3..7).should cover(@all_results.size)
    end

    # Google might include news in some responses, so we don't compare them with ==
    it "takes the first 2 pages of results" do
      @page_one = SearchLogger::GoogleParser.new.query('amazon').per_page(1).page(1)
      @page_two = SearchLogger::GoogleParser.new.query('amazon').per_page(1).page(2)
      result = @page_one.search.map { |e| e.title } + @page_two.search.map { |e| e.title }
      @all_results.should include(result.first, result.last)
    end

    it "has the right position numbers" do
      @page_one = SearchLogger::GoogleParser.new.query('amazon').per_page(1).page(1).search
      @page_two = SearchLogger::GoogleParser.new.query('amazon').per_page(1).page(2).last_result(@page_one).search
      @page_one.first.position.should == 1
      @page_two.first.position.should == @page_one.size + 1
    end
  end

  context "for each result" do
    it "extracts title" do
      @response.each { |e| e.title.should_not == "" }
    end

    it "extract URL" do
      @response.each { |e| e.url.should_not == "" }
    end

    it "extract description" do
      @response.each { |e| e.description.should_not == "" }
    end
  end

  describe "parsing a mocked response" do
    let(:result_double) { File.open('spec/support/file_repository/google_result.html').read }
    context "item 1" do
      subject { SearchLogger::GoogleParser.new(result_double).search[0] }

      its(:title)       { should == "Amazon.com: Online Shopping for Electronics, Apparel, Computers ..." }
      its(:url)         { should == "http://www.amazon.com/" }
      its(:description) { should == "Online retailer of books, movies, music and games along with electronics, toys, apparel, sports, tools, groceries and general home and garden items. Region 1 ..." }
      its(:position)    { should == 1 }
    end

    context "item 7" do
      subject { SearchLogger::GoogleParser.new(result_double).search[7] }

      its(:title)       { should == "Kindle Fire - Full Color 7\" Multi-Touch Display with Wi ... - Amazon.com" }
      its(:url)         { should == "http://www.amazon.com/Kindle-Fire-Amazon-Tablet/dp/B0051VVOB2" }
      its(:description) { should == "The new Kindle Fire for only $199 is more than a tablet - it's a Kindle with a color touchscreen for web, movies, music, apps, games, reading & more." }
      its(:position)    { should == 8 }
    end

    context "item 18" do
      subject { SearchLogger::GoogleParser.new(result_double).search[18] }

      its(:title)       { should == "Amazon.ca Books: Online shopping for literature & fiction, new ..." }
      its(:url)         { should == "http://www.amazon.ca/books-used-books-textbooks/b?ie=UTF8&node=916520" }
      its(:description) { should == "Online shopping for books in all categories, including literature & fiction, new & used textbooks, biographies, cookbooks, children's books, computer manuals, ..." }
      its(:position)    { should == 19 }
    end
  end
end