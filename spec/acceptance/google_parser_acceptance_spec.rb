# encoding: utf-8
require "spec_helper"

describe "Google parser" do
  before :all do
    @response = SearchLogger::GoogleParser.new.query('test').per_page(5).search
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
    response = SearchLogger::GoogleParser.new.query('amazon').search
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
    let(:result_double) { File.open('spec/support/file_repository/google_result_2.html').read }
    context "item 1" do
      subject { SearchLogger::GoogleParser.new(result_double).search[0] }

      its(:title)       { should == "Xovi: mehr als ein SEO Tool - online Marketing (SEO, SEM, Affiliate ..." }
      its(:url)         { should == "http://www.xovi.de/" }
      its(:description) { should == "Setzen Sie unsere SEO Software f?r Ihr Online Marketing Budget intelligent und erfolgreich ein. Verlassen Sie sich nicht auf Ihr Bauchgef?hl oder Ihre Erfahrung ..." }
      its(:position)    { should == 1 }
    end

    context "item 7" do
      subject { SearchLogger::GoogleParser.new(result_double).search[7] }

      its(:title)       { should == "SEO Company India" }
      its(:url)         { should == "http://www.seosoftwareservices.com/" }
      its(:description) { should == "SEO Company India Services SEO Company Offers Standard SEO Company to enhance your ranking.We Provide Professional SEO Company India, SEO India ..." }
      its(:position)    { should == 8 }
    end

    context "item 18" do
      subject { SearchLogger::GoogleParser.new(result_double).search[18] }

      its(:title)       { should == "Microsite Masters Rank Tracker - Accurate Keyword Tracking for ..." }
      its(:url)         { should == "http://www.micrositemasters.com/" }
      its(:description) { should == "Microsite Masters search engine optimization software tracks keywords across multiple URL's, ..." }
      its(:position)    { should == 19 }
    end
  end
end