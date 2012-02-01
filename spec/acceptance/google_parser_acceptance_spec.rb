require "spec_helper"

describe "Google parser" do
  before :all do
    @response = SearchLogger::GoogleParser.new.query('amazon').search
  end

  it "searches for a keyword" do
    @response.should be_kind_of Array
  end

  pending "returns 100 result per page"
  pending "take the 2 first pages of results"
  pending "parse the response and return a list of results"
  context "each result" do
    pending "extract title"
    pending "extract URL"
    pending "extract description"
    pending "extract the result position"
  end
  pending "extract keywords from the XML file"
end