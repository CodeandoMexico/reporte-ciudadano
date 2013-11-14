class ServiceRequestSerializer < ActiveModel::Serializer
  self.root = 'request'
  attributes :service_request_id, :status, :status_notes, :service_name,
             :service_code, :description, :requested_datetime, :updated_datetime,
             :address, :lat, :long, :media_url

  def service_request_id
    object.id
  end

  def status
    object.status.name
  end

  def status_notes
    messages = object.status.messages.where(service_id: object.service_id)
    messages.first.try(:content)
  end

  def service_name
    object.service.name
  end

  def service_code
    object.service_id
  end

  def requested_datetime
    object.created_at
  end

  def updated_datetime
    object.updated_at
  end

  def long
    object.lng.to_f
  end

  def lat
    object.lat.to_f
  end

end
