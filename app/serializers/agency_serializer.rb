class AgencySerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :organisation_id
end
