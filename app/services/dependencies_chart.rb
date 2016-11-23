module DependenciesChart
  def self.data(available_dependencies)
    available_dependencies.each_with_index.map do |dependency, index|
      {
        id: index + 1,
        name: dependency
      }.merge(requests_by_status(dependency))
    end
  end

  def self.general_report_csv(available_dependencies)
    statuses = Status.all
    GeneralReport.new(available_dependencies, statuses)
  end

  private

  def self.requests_by_status(dependency)
    statuses.map do |status|
      [
        :"status_#{status.id}",
        ServiceRequest.with_status_and_dependency(status.id, dependency).count
      ]
    end.to_h
  end

  def self.statuses
    Status.all
  end

  class GeneralReport
    def initialize(dependencies, statuses)
      @dependencies = dependencies
      @statuses = statuses
    end

    def to_csv
      [file, filename]
    end

    private

    def columns_headers
      [ "Dependencia" ] + statuses.map(&:name)
    end

    def rows
      dependencies.map do |dependency|
        row_for(dependency).to_a
      end
    end

    def filename
      "Reporte_general_quejas_por_dependencia_#{Date.today.to_s.gsub(/[\/]/,'-')}.csv"
    end

    def table
      [columns_headers] + rows
    end

    def file
      CSV.generate do |csv|
        table.each { |row| csv << row }
      end
    end

    def row_for(dependency)
      [ dependency.to_s,
        statuses.map{ |status| ServiceRequest.with_status_and_dependency(status.id, dependency).count.to_s }
      ].flatten
    end

    attr_reader :dependencies, :statuses
  end
end