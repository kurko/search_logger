require "spec_helper"

describe "Google parser" do
  before :all do
    @response = SearchLogger::GoogleParser.new.query('amazon').search
  end

  it "searches for a keyword" do
    @response.should be_kind_of Array
  end

  # depending on the query string, Google returns more or less than 100 links
  it "returns around 100 results per page by default" do
    @response.size.should > 95
    @response.size.should < 105
  end

  context "multiple pages" do
    before :all do
      @all_results = SearchLogger::GoogleParser.new.query('amazon').per_page(2).search.map { |e| e.title }
    end

    it "response should return 2 results" do
      @all_results.size.should == 2
    end
    it "take the first 2 pages of results" do
      @page_one = SearchLogger::GoogleParser.new.query('amazon').per_page(1).page(1).search.map { |e| e.title }
      @page_two = SearchLogger::GoogleParser.new.query('amazon').per_page(1).page(2).search.map { |e| e.title }
      @all_results.should == @page_one + @page_two
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

    pending "extract the result position"
  end

  describe "parsing a mocked response" do
    let(:result_double) { File.open('spec/support/file_repository/google_result.html').read }
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

    context "item 18" do
      subject { SearchLogger::GoogleParser.new(result_double).search[18] }

      its(:title)       { should == "Amazon.ca Books: Online shopping for literature & fiction, new ..." }
      its(:url)         { should == "http://www.amazon.ca/books-used-books-textbooks/b?ie=UTF8&node=916520" }
      its(:description) { should == "Online shopping for books in all categories, including literature & fiction, new & used textbooks, biographies, cookbooks, children's books, computer manuals, ..." }
    end
  end
end