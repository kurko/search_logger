require "spec_helper"

describe "Data persistence" do
  let(:data) {
    [ {searched_keyword: "amazon", title: "This is a title", url: "www.github.com", description: "First description.", position: 1},
      {searched_keyword: "amazon", title: "This is the second title", url: "www.github.com", description: "Second description.", position: 2},
      {searched_keyword: "amazon", title: "This is the third title", url: "www.github.com", description: "Third description.", position: 3}
    ]
  }

  before do
    @persistence = SearchLogger::Persistence.new
    @persistence.client.query("DELETE FROM google_results")
  end

  it "stores an array of values in the database" do
    @persistence.data(data)
    @persistence.table('google_results').save
    @another_persistence_object = SearchLogger::Persistence.new
    saved_data = @another_persistence_object.table("google_results").load_data
    saved_data.map { |e| e.tap { |x| x.delete(:id) }.tap { |x| x.delete(:created_at) } }.should == data
  end

  pending "when there's no database created"

end