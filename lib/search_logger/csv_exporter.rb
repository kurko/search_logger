require 'csv'

class CSVExporter
  def export(data, options)
    @data = data
    @to = options[:to]

    save_to_file unless @data.empty?
  end

  def save_to_file
    CSV.open(@to, "wb") do |csv|
      csv << %w{keyword position url title description}
      @data.each do |d|
        csv << [d[:searched_keyword], d[:position], d[:url], d[:title], d[:description]]
      end
    end
  end

end