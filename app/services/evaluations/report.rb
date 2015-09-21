module Evaluations
  class Report
    def initialize(filename, columns_headers, rows)
      @filename = filename
      @columns_headers = columns_headers
      @rows = rows
    end

    def to_csv
      [file, filename]
    end

    private

    def table
      [columns_headers] + rows
    end

    def file
      CSV.generate do |csv|
        table.each { |row| csv << row }
      end
    end

    attr_reader :filename, :columns_headers, :rows
  end
end