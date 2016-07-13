module ServiceRequests
  class ServiceRequestsFile

    def initialize(service_requests)
      @service_requests = service_requests
      @filename = filename || "default_name"
    end

    def to_csv
      [file, filename]
    end

    private

    attr_reader :service_requests, :filename

    def table
       [columns_headers] + rows
    end

    def columns_headers
      [ "ID", "Descripción", "Dirección", "Nombre del usuario", "Correo electrónico", "Fecha de creación", "Fecha de última modificación", "Estatus", "Nombre de los servidores públicos" ]
    end

    def rows
      service_requests.map do |request|
        row_for(request)
      end
    end

    def row_for(request)
      [request.id.to_s,
          request.description.to_s,
          request.address.to_s,
          request.requester.name.to_s,
          request.requester.email.to_s,
          request.created_at.to_formatted_s(:iso8601).to_s,
          request.updated_at.to_formatted_s(:iso8601).to_s,
          request.status.name.to_s,
          request.public_servants.map{|a| a.name.to_s }.join("; ")]
    end

    ##
    ##  File Methods
    ##
    def filename
      "Reporte_quejas_#{Date.today.to_s.gsub(/[\/]/,'-')}.csv"
    end


    def file
      CSV.generate do |csv|
        table.each { |row| csv << row }
      end
    end


  end
end