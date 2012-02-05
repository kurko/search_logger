require "mysql2"
module SearchLogger
  class Persistence
    attr_accessor :table, :client
    attr_reader :data

    def initialize
      @data = []
      @client = ::Mysql2::Client.new(host: "localhost", username: "root", database: "search_logger")
    end

    # sets up the operation properties

    def data(data = [])
      return @data if data.empty?
      data = [data] if data.is_a?(Hash)
      @data = data
      self
    end

    def table(table = nil)
      return @table unless table
      @table = table
      self
    end

    def save_to_sql
      fields, values = [], []
      fields_complete = false
      # gathers fields and values
      data.each_with_index do |e, index|
        values[index] = []
        e.each do |key, value|
          fields << key.to_s unless fields_complete
          values[index] << value.to_s
        end
        fields_complete = true
      end

      # creates values string
      each_record_values = []
      values.each do |e|
        each_record_values << "('#{e.join("', '")}')"
      end
      sql = "INSERT INTO #{table} (#{fields.join(', ')}) VALUES #{each_record_values.join(', ')}"
    end

    def save(client = @client)
      client.query(save_to_sql)
    end

    def load_to_sql
      "SELECT * FROM #{table}"
    end

    def load_data(client = @client)
      [].tap do |e|
        client.query(load_to_sql).each(symbolize_keys: true) { |row| e << row }
      end
    end
  end
end