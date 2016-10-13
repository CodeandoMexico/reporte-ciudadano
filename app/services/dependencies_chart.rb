module DependenciesChart
  def self.data(available_dependencies)
    available_dependencies.each_with_index.map do |dependency, index|
      {
        id: index + 1,
        name: dependency
      }.merge(requests_by_status(dependency))
    end
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
end