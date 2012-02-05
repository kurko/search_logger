require "spec_helper"

describe SearchLogger::Persistence do
  let(:data_to_save) {
    [ {searched_keyword: "amazon", title: "This is a title", description: "First description.", url: "www.github.com", position: 1},
      {searched_keyword: "amazon", title: "This is the second title", description: "Second description.", url: "www.github.com", position: 2},
      {searched_keyword: "amazon", title: "This is the third title", description: "Third description.", url: "www.github.com", position: 3}
    ]
  }

  before do
    @persistence = SearchLogger::Persistence.new
  end

  describe "#data" do
    it "has the correct value" do
      @persistence.data(data_to_save).data.should == data_to_save
    end
  end

  describe "#table" do
    it "sets the table to work with" do
      @persistence.table("whatever").table.should == "whatever"
    end
  end

  describe "#load_data" do
    it "triggers mysql2" do
      @mysql2 = double("mysql2")
      @mysql2.stub_chain(:query, :each)
      @mysql2.should_receive(:query).with(an_instance_of(String))
      @persistence.table('my_table').load_data(@mysql2)
    end
  end

  describe "#load_to_sql" do
    it "creates the correct sql query" do
      @persistence.table('my_table').load_to_sql.should == "SELECT * FROM my_table"
    end
  end

  describe "#save" do
    it "triggers mysql2" do
      @mysql2 = double("mysql2")
      @mysql2.should_receive(:query).with(an_instance_of(String))
      @persistence.table('my_table').save(@mysql2)
    end
  end

  describe "#save_to_sql" do
    it "creates the correct sql query when one record" do
      data = { 
        searched_keyword: "amazon",
        title: "This is a title",
        description: "First description.",
        url: "www.github.com",
        position: 1
      }

      @persistence.data(data).table('my_table').save_to_sql.should == 
        "INSERT INTO my_table (searched_keyword, title, description, url, position) VALUES ('amazon', 'This is a title', 'First description.', 'www.github.com', '1')"
    end

    it "creates the correct sql query when two records" do
      data = [
        { 
          searched_keyword: "amazon",
          title: "This is a title",
          description: "First description.",
          url: "www.github.com",
          position: 1
        },
        { 
          searched_keyword: "amazon",
          title: "This is a title",
          description: "First description.",
          url: "www.github.com",
          position: 1
        }
      ]

      @persistence.data(data).table('my_table').save_to_sql.should == 
        "INSERT INTO my_table (searched_keyword, title, description, url, position) VALUES ('amazon', 'This is a title', 'First description.', 'www.github.com', '1'), ('amazon', 'This is a title', 'First description.', 'www.github.com', '1')"
    end
  end
end