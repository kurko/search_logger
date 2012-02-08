require 'csv'

class CSVExporter
  def export(data, options)
    @data = data
    @to = options[:to]

    save_to_file unless @data.empty?
  end

  def save_to_file
    CSV.open(@to, "wb") do |csv|
      csv << @data.first.keys
      @data.each do |data|
        csv << data.values
      end
    end
  end

end