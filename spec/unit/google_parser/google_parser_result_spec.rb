require "spec_helper"

describe SearchLogger::GoogleParser::Result do
  let(:result_double) { File.open('spec/support/file_repository/google_result_2.html').read }

  describe "parsing a single result", wip: true do
    before do
      @node = Nokogiri::HTML.parse(result_double).css('li.g').first
    end

    subject { SearchLogger::GoogleParser::Result.new(@node, 10, 'amazon').parse_normal_result }

    its(:title)       { should == "Xovi: mehr als ein SEO Tool - online Marketing (SEO, SEM, Affiliate ..." }
    its(:url)         { should == "http://www.xovi.de/" }
    its(:description) { should == "Setzen Sie unsere SEO Software f?r Ihr Online Marketing Budget intelligent und erfolgreich ein. Verlassen Sie sich nicht auf Ihr Bauchgef?hl oder Ihre Erfahrung ..." }
    its(:position)    { should == 10 }
    its(:searched_keyword) { should == 'amazon' }
  end

  describe "#parse" do
    context "normal result" do
      before do
        @node = Nokogiri::HTML.parse(result_double).css('li.g').first
      end

      subject { SearchLogger::GoogleParser::Result.new(@node, 2, 'amazon').parse }

      its(:title)       { should == "Amazon.com: Online Shopping for Electronics, Apparel, Computers ..." }
      its(:url)         { should == "http://www.amazon.com/" }
      its(:description) { should == "Online retailer of books, movies, music and games along with electronics, toys, apparel, sports, tools, groceries and general home and garden items. Region 1 ..." }
      its(:position)    { should == 2 }
      its(:searched_keyword) { should == 'amazon' }
    end

    context "newsbox" do
      before do
        @node = Nokogiri::HTML.parse(result_double).css('li#newsbox').first
      end
      
      subject { SearchLogger::GoogleParser::Result.new(@node, 6, 'amazon').parse }

      its(:title)       { should == "Amazon fourth quarter profit falls on heavy expenses" }
      its(:url)         { should == "http://www.usatoday.com/tech/news/story/2012-01-31/amazon-earnings/52907866/1" }
      its(:description) { should == "By Roger Yu, USA TODAY Despite rising sales, Amazon, the largest Internet retailer, reported a 57% decline in its fourth-quarter profit due to heavy ..." }
      its(:position)    { should == 6 }
      its(:searched_keyword) { should == 'amazon' }
    end
  end

  describe "#to_ary" do
    context "normal result" do 
      before do
        @node = Nokogiri::HTML.parse(result_double).css('li.g').first
      end

      subject { SearchLogger::GoogleParser::Result.new(@node, 2, 'amazon').parse.as_ary }

      it "has a title" do
        subject[:title].should == "Amazon.com: Online Shopping for Electronics, Apparel, Computers ..."
      end

      it "has an url" do
        subject[:url].should == "http://www.amazon.com/"
      end

      it "has a description" do
        subject[:description].should == "Online retailer of books, movies, music and games along with electronics, toys, apparel, sports, tools, groceries and general home and garden items. Region 1 ..."
      end

      it "has a position" do
        subject[:position].should == 2
      end

      it "has a keyword" do
        subject[:searched_keyword].should == 'amazon'
      end
    end
  end
end