module DynamicReports
  class ServicePublicServantsReport
    include Datagrid

    scope do
      Admin.includes(:services).includes(:admins_services).distinct(:id)
    end

    def name_select
      scope.uniq(:id).order(:id).map{|a| ["#{a.name.presence || ""} #{a.surname.presence || ""} #{a.second_surname.presence || ""}", a.id]}
    end

    def organisation_select
      scope
        .select(:organisation_id)
        .uniq
        .order(:organisation_id)
        .map { |d| [d.dependency, d.organisation_id] }
    end

    def agency_select
      scope.select(:agency_id)
        .uniq
        .order(:agency_id)
        .map { |d| [d.administrative_unit, d.agency_id] }
    end

    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.year.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.created_at'))  do |value, scope, grid|
      scope.where("admins.created_at between ? and ? ", value.first + 3.days, value.last + 1.days)
    end

    filter(:name,
           :enum,
           :select => :name_select,
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.name')) do |value, scope, grid|
      scope.where(id: value)
    end

    filter(:organisation_id,
           :enum,
           :select => :organisation_select,
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))

    filter(:agency_id,
           :enum,
           :select => :agency_select,
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),)

    filter(:disabled, :xboolean, header: I18n.t('activerecord.attributes.dynamic_reports.active')) do |value, scope, grid|
        scope.where(disabled: !value)
    end
    filter(:is_service_admin, :xboolean, header: I18n.t('activerecord.attributes.dynamic_reports.is_service_admin'))
    filter(:is_observer, :xboolean, header: I18n.t('activerecord.attributes.dynamic_reports.is_observer'))



    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:created_at, header: I18n.t('activerecord.attributes.dynamic_reports.created_at')) do |record|
      record.created_at.to_date
    end
    column(:name, header: I18n.t('activerecord.attributes.dynamic_reports.name')) do |record|
      "#{record.name.presence || ""} #{record.surname.presence || ""} #{record.second_surname.presence || ""}"
    end

    column(:organisation_id, header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.dependency
    end

    column(:agency_id, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.administrative_unit
    end

    column(:disabled, header: I18n.t('activerecord.attributes.dynamic_reports.active')) do |record|
      I18n.t("activerecord.attributes.dynamic_reports.affirmation.#{!record.disabled}")
    end
    column(:is_service_admin, header: I18n.t('activerecord.attributes.dynamic_reports.is_service_admin'))do |record|
      I18n.t("activerecord.attributes.dynamic_reports.affirmation.#{!!record.is_service_admin}")
    end

    column(:is_observer, header: I18n.t('activerecord.attributes.dynamic_reports.is_observer')) do |record|
      I18n.t("activerecord.attributes.dynamic_reports.affirmation.#{record.is_observer}")
    end
    column(:service_names, header: I18n.t('activerecord.attributes.dynamic_reports.service_names')) do |record|
      if record.is_service_admin
        record.managed_services.map(&:name).join("; ")
      else
        record.services.map{|b| "#{b.name || b.managed_services.map(&:name)}"}.join("; ")
      end
    end
  end
end
