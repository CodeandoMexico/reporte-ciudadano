module DynamicReports

  class ServicePerformanceReport
    include Datagrid

    scope do
      ServiceReport.joins(:service)
    end
    filter(:id,
           :enum,
           :select => Service.all.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    filter(:created_at,
          :date,
          :range => true,
          :default => proc { [1.month.ago.to_date, Date.today]},
          header: I18n.t('activerecord.attributes.dynamic_reports.date_range')) do |value, scope, grid|

     scope.where("service_reports.created_at between ? and ? ", value.first + 3.days, value.last + 1.days)
    end

    filter(:dependency,
           :enum,
           :select => scope.select("services.dependency").uniq.order("services.dependency").map(&:dependency),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))  do |value, scope, grid|

      scope.where("services.dependency similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:administrative_unit,
           :enum,
           :select => scope.select("services.administrative_unit").
               uniq.order("services.administrative_unit").map(&:administrative_unit),
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),) do |value, scope, grid|

      scope.where("services.administrative_unit similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_name,
           :enum,
           :select => scope.select("services.name").uniq.order("services.name").map(&:name),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |value, scope, grid|

      scope.where("services.name similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    column(:date_start, order:"service_reports.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end, order:"service_reports.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:dependency, order:"services.dependency", header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.service.dependency
    end
    column(:administrative_unit, order: "services.administrative_unit", header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.service.administrative_unit
    end
    column(:service_name,order: "services.name" , header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.service.name
    end
    column(:service_surveys, header: I18n.t('activerecord.attributes.dynamic_reports.service_surveys_count')) do |record|
      record.service.service_surveys.count
    end
    column(:respondents_count, header: I18n.t('activerecord.attributes.dynamic_reports.respondents_count')) do |record|
      "#{record.respondents_count}"
    end
  end

  class CisServicesReport
    include Datagrid

    scope do
      CisReport
    end

    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))


    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.month.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.date_range'))

    filter(:cis_id,
           :enum,
           :select => scope.select(:cis_id).uniq.map{|a| a}.flatten.uniq.map{|a| [Services.service_cis_label(a.cis_id.to_s), a.cis_id]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where(cis_id: value.uniq.join(","))
    end
    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:date_start, order:"created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end, order:"created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:cis_name, order: "cis_id", header: I18n.t('activerecord.attributes.dynamic_reports.cis'))do |record|
      Services.service_cis_label(record.cis_id.to_s)
    end
    column(:cis_services,  header: I18n.t('activerecord.attributes.dynamic_reports.cis_services'))do |record|
      Service.for_cis(record.cis_id).map{|service| "#{service.name}"}.join("; ")
    end
    column(:positive_overall_perception, header: I18n.t('activerecord.attributes.dynamic_reports.positive_overall_perception')) do |record|
      "#{record.positive_overall_perception.round(2)}%"
    end
    column(:respondents_count, header: I18n.t('activerecord.attributes.dynamic_reports.respondents_count')) do |record|
      "#{record.respondents_count}"
    end
    column(:overall_areas, order: false, header: I18n.t('activerecord.attributes.dynamic_reports.transparency')) do |record|
      "#{record.overall_areas[:transparency].round(2)}%"
    end
    column(:overall_areas, order: false, header: I18n.t('activerecord.attributes.dynamic_reports.performance')) do |record|
      "#{record.overall_areas[:performance].round(2)}%"
    end
    column(:overall_areas, order: false, header: I18n.t('activerecord.attributes.dynamic_reports.quality_service')) do |record|
      "#{record.overall_areas[:quality_service].round(2)}%"
    end
    column(:overall_areas, order: false, header: I18n.t('activerecord.attributes.dynamic_reports.accessibility')) do |record|
      "#{record.overall_areas[:accessibility].round(2)}%"
    end
    column(:overall_areas, order: false, header: I18n.t('activerecord.attributes.dynamic_reports.infrastructure')) do |record|
      "#{record.overall_areas[:infrastructure].round(2)}%"
    end
    column(:overall_areas, order: false, header: I18n.t('activerecord.attributes.dynamic_reports.public_servant')) do |record|
      "#{record.overall_areas[:public_servant].round(2)}%"
    end


  end

  class ServiceDemandReport
    include Datagrid

    scope do
      Service.includes(:service_surveys).joins(:service_reports).uniq("service_surveys.id")
    end

    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.month.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.created_at'))

    filter(:dependency,
           :enum,
           :select => scope.select(:dependency).uniq.order(:dependency).map(&:dependency),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))

    filter(:administrative_unit, :enum, :select => scope.select(:administrative_unit).
                                   uniq.order(:administrative_unit).map(&:administrative_unit),
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),)

    filter(:cis,
           :enum,
           :select => scope.select(:cis).map{|a| a.cis}.flatten.uniq.map{|a| [Services.service_cis_label(a), a]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where("services.cis similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_name,
           :enum,
           :select => scope.select(:name).uniq.order(:name).map(&:name),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |value, scope, grid|

      scope.where("services.name similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_type,
           :enum,
           :select => scope.select(:service_type).uniq.order(:service_type).
               map{|a| ["#{I18n.t("service_type_options.#{a.service_type}")}", a.service_type]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_type')) do |value, scope, grid|

      scope.where("services.service_type similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:date_start, header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.service_surveys.last.created_at.to_date - 3.days
    end
    column(:date_end, header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.service_surveys.last.created_at.to_date
    end
    column(:dependency, header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.dependency
    end
    column(:administrative_unit, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.administrative_unit
    end
    column(:service_name, order: "services.name", header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.name + " (#{I18n.t("service_type_options.#{record.service_type}")})"
    end
    column(:service_survey_names, order: "service_surveys.title", header: I18n.t('activerecord.attributes.dynamic_reports.service_survey_names')) do |record|
      record.service_surveys.map{|a| a.title}.join("; ")
    end
    column(:cis, header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.cis.map do |cis_id|
        Services.service_cis_label(cis_id)
      end.join(";")
    end
    column(:service_surveys, header: I18n.t('activerecord.attributes.dynamic_reports.service_surveys_count')) do |record|
      record.service_surveys.count
    end
    column(:respondents_count, header: I18n.t('activerecord.attributes.dynamic_reports.respondents_count')) do |record|
      record.service_reports.last.respondents_count
    end

  end

  class ServicePublicServantsReport
    include Datagrid

    scope do
      Admin.includes(:services).includes(:admins_services).distinct(:id)
    end

    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.month.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.created_at'))

    filter(:name,
           :enum,
           :select => scope.uniq(:id).order(:id).map{|a| ["#{a.name.presence || ""} #{a.surname.presence || ""} #{a.second_surname.presence || ""}", a.id]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.name')) do |value, scope, grid|
      scope.where(id: value)
    end
    filter(:dependency,
           :enum,
           :select => scope.select(:dependency).uniq.order(:dependency).map(&:dependency),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))
    filter(:administrative_unit, :enum, :select => scope.select(:administrative_unit).
                                   uniq.order(:administrative_unit).map(&:administrative_unit),
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
    column(:dependency, header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))
    column(:administrative_unit, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'))
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

  class AllPublicServantsReport
    include Datagrid

    scope do
      ServiceReport.joins(:service)
    end
    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.month.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.date_range')) do |value, scope, grid|

      scope.where("service_reports.created_at between ? and ? ", value.first + 3.days, value.last + 1.days)
    end

    filter(:dependency,
           :enum,
           :select => scope.select("services.dependency").uniq.order("services.dependency").map(&:dependency),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))do |value, scope, grid|

      scope.where("services.dependency similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:administrative_unit,
           :enum,
           :select => scope.select("services.administrative_unit").
               uniq.order("services.administrative_unit").map(&:administrative_unit),
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),) do |value, scope, grid|

      scope.where("services.administrative_unit similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:cis,
           :enum,
           :select => scope.map{|a| a.service.cis}.flatten.uniq.map{|a| [Services.service_cis_label(a), a]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where("services.cis similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:status,
           :enum,
           :select => scope.select(:status).uniq.map(&:status),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.status')) do |value, scope, grid|

      scope.where("services.status similar to ? ", "(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:date_start, :order => "service_reports.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end,:order => "service_reports.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:service_name, :order => "services.name",header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.service.name
    end
    column(:dependency,:order => "services.dependency", header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.service.dependency
    end
    column(:administrative_unit, order: "services.administrative_unit", header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.service.administrative_unit
    end
    column(:cis, order: "services.cis", header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.service.cis.map{|service| "#{Services.service_cis_label(service)}"}.join("; ")
    end
    column(:areas_results, header: I18n.t('activerecord.attributes.dynamic_reports.public_servant_evaluation')) do |record|
        "#{record.overall_areas[:public_servant].round(2)}%"
    end
  end

  class WorstPublicServantsReport
    include Datagrid

    scope do
      ServiceReport.joins(:service)
    end
    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.month.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.date_range'))

    filter(:dependency,
           :enum,
           :select => scope.select("services.dependency").uniq.order("services.dependency").map(&:dependency),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))  do |value, scope, grid|

      scope.where("services.dependency similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:administrative_unit,
           :enum,
           :select => scope.select("services.administrative_unit").
               uniq.order("services.administrative_unit").map(&:administrative_unit),
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),) do |value, scope, grid|

      scope.where("services.administrative_unit similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:cis,
           :enum,
           :select => scope.map{|a| a.service.cis}.flatten.uniq.map{|a| [Services.service_cis_label(a), a]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where("services.cis similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:status,
           :enum,
           :select => scope.select(:status).uniq.map(&:status),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.status')) do |value, scope, grid|

      scope.where("services.status similar to ? ", "(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:date_start, :order => "service_reports.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end,:order => "service_reports.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:service_name, :order => "services.name",header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.service.name
    end
    column(:dependency,:order => "services.dependency", header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.service.dependency
    end
    column(:administrative_unit, order: "services.administrative_unit", header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.service.administrative_unit
    end
    column(:cis, order: "services.cis", header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.service.cis.map{|service| "#{Services.service_cis_label(service)}"}.join("; ")
    end
    column(:areas_results, header: I18n.t('activerecord.attributes.dynamic_reports.public_servant_evaluation')) do |record|
      if record.overall_areas[:public_servant] < 70
        "#{record.overall_areas[:public_servant].round(2)}%"
      else
        I18n.t('activerecord.attributes.dynamic_reports.not_qualified')
      end
    end
  end

  class BestPublicServantsReport
    include Datagrid

    scope do
      ServiceReport.joins(:service)
    end
    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.month.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.date_range'))

    filter(:dependency,
           :enum,
           :select => scope.select("services.dependency").uniq.order("services.dependency").map(&:dependency),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))  do |value, scope, grid|

      scope.where("services.dependency similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:administrative_unit,
           :enum,
           :select => scope.select("services.administrative_unit").
               uniq.order("services.administrative_unit").map(&:administrative_unit),
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),) do |value, scope, grid|

      scope.where("services.administrative_unit similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:cis,
           :enum,
           :select => scope.map{|a| a.service.cis}.flatten.uniq.map{|a| [Services.service_cis_label(a), a]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where("services.cis similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:status,
           :enum,
           :select => scope.select(:status).uniq.map(&:status),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.status')) do |value, scope, grid|

      scope.where("services.status similar to ? ", "(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:date_start, :order => "service_reports.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end,:order => "service_reports.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:service_name, :order => "services.name",header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.service.name
    end
    column(:dependency,:order => "services.dependency", header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.service.dependency
    end
    column(:administrative_unit, order: "services.administrative_unit", header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.service.administrative_unit
    end
    column(:cis, order: "services.cis", header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.service.cis.map{|service| "#{Services.service_cis_label(service)}"}.join("; ")
    end
    column(:areas_results, header: I18n.t('activerecord.attributes.dynamic_reports.public_servant_evaluation')) do |record|
     if record.overall_areas[:public_servant].round(2) > 85
      "#{record.overall_areas[:public_servant].round(2)}%"
     else
       I18n.t('activerecord.attributes.dynamic_reports.not_qualified')
     end


    end
  end

  class  AllServiceReport
    include Datagrid

    scope do
      Service.joins(:service_surveys_reports).uniq
    end

    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.month.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.date_range'))

    filter(:dependency,
           :enum,
           :select => scope.select(:dependency).uniq.order(:dependency).map(&:dependency),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))

    filter(:administrative_unit, :enum, :select => scope.select(:administrative_unit).
                                   uniq.order(:administrative_unit).map(&:administrative_unit),
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),)

    filter(:cis,
           :enum,
           :select => scope.select(:cis).map{|a| a.cis}.flatten.uniq.map{|a| [Services.service_cis_label(a), a]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where("services.cis similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_name,
           :enum,
           :select => scope.select(:name).uniq.order(:name).map(&:name),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |value, scope, grid|

      scope.where("services.name similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_type,
           :enum,
           :select => scope.select(:service_type).uniq.order(:service_type).
               map{|a| ["#{I18n.t("service_type_options.#{a.service_type}")}", a.service_type]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_type')) do |value, scope, grid|

      scope.where("services.service_type similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:status,
           :enum,
           :select => scope.select(:status).uniq.map(&:status),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.status')) do |value, scope, grid|

      scope.where("services.status similar to ? ", "(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:date_start, :order => "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end, :order => "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:dependency, :order => "services.dependency", header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.dependency
    end
    column(:administrative_unit, :order => "services.administrative_unit", header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.administrative_unit
    end

    column(:cis, :order => "services.cis", header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.cis.map do |cis_id|
        Services.service_cis_label(cis_id)
      end.join(";")
    end

    column(:service_name, :order => "services.name", header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.name + " (#{I18n.t("service_type_options.#{record.service_type}")})"
    end

    column(:overall_satisfaction, header: I18n.t('activerecord.attributes.dynamic_reports.overall_satisfaction')) do |record|
      elementos= record.service_surveys_reports.map(&:positive_overall_perception)
      unless elementos.blank?
          (elementos.reduce(:+)/elementos.count).round(2).to_s + "%"
      end
    end
  end

  class  BestServiceReport
    include Datagrid

    scope do
      Service.joins(:service_surveys_reports).uniq
    end

    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.month.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.date_range'))

    filter(:dependency,
           :enum,
           :select => scope.select(:dependency).uniq.order(:dependency).map(&:dependency),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))

    filter(:administrative_unit, :enum, :select => scope.select(:administrative_unit).
                                   uniq.order(:administrative_unit).map(&:administrative_unit),
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),)

    filter(:cis,
           :enum,
           :select => scope.select(:cis).map{|a| a.cis}.flatten.uniq.map{|a| [Services.service_cis_label(a), a]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where("services.cis similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_name,
           :enum,
           :select => scope.select(:name).uniq.order(:name).map(&:name),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |value, scope, grid|

      scope.where("services.name similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_type,
           :enum,
           :select => scope.select(:service_type).uniq.order(:service_type).
               map{|a| ["#{I18n.t("service_type_options.#{a.service_type}")}", a.service_type]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_type')) do |value, scope, grid|

      scope.where("services.service_type similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:status,
           :enum,
           :select => scope.select(:status).uniq.map(&:status),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.status')) do |value, scope, grid|

      scope.where("services.status similar to ? ", "(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:date_start, :order => "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end, :order => "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:dependency, :order => "services.dependency", header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.dependency
    end
    column(:administrative_unit, :order => "services.administrative_unit", header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.administrative_unit
    end

    column(:cis, :order => "services.cis", header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.cis.map do |cis_id|
        Services.service_cis_label(cis_id)
      end.join(";")
    end

    column(:service_name, :order => "services.name", header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.name + " (#{I18n.t("service_type_options.#{record.service_type}")})"
    end

    column(:overall_satisfaction, header: I18n.t('activerecord.attributes.dynamic_reports.overall_satisfaction')) do |record|
      elementos= record.service_surveys_reports.map(&:positive_overall_perception)
      unless elementos.blank?
        if (elementos.reduce(:+)/elementos.count).round(2) > 84
          (elementos.reduce(:+)/elementos.count).round(2).to_s + "%"
        else
          I18n.t('activerecord.attributes.dynamic_reports.not_qualified')
        end
      end
    end
  end

  class  WorstServiceReport
    include Datagrid

    scope do
      Service.joins(:service_surveys_reports).uniq
    end

    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.month.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.date_range'))

    filter(:dependency,
           :enum,
           :select => scope.select(:dependency).uniq.order(:dependency).map(&:dependency),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))

    filter(:administrative_unit, :enum, :select => scope.select(:administrative_unit).
                                   uniq.order(:administrative_unit).map(&:administrative_unit),
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),)

    filter(:cis,
           :enum,
           :select => scope.select(:cis).map{|a| a.cis}.flatten.uniq.map{|a| [Services.service_cis_label(a), a]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where("services.cis similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_name,
           :enum,
           :select => scope.select(:name).uniq.order(:name).map(&:name),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |value, scope, grid|

      scope.where("services.name similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_type,
           :enum,
           :select => scope.select(:service_type).uniq.order(:service_type).
               map{|a| ["#{I18n.t("service_type_options.#{a.service_type}")}", a.service_type]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_type')) do |value, scope, grid|

      scope.where("services.service_type similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:status,
           :enum,
           :select => scope.select(:status).uniq.map(&:status),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.status')) do |value, scope, grid|

      scope.where("services.status similar to ? ", "(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:date_start, :order => "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end, :order => "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:dependency, :order => "services.dependency", header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.dependency
    end
    column(:administrative_unit, :order => "services.administrative_unit", header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.administrative_unit
    end

    column(:cis, :order => "services.cis", header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.cis.map do |cis_id|
        Services.service_cis_label(cis_id)
      end.join(";")
    end

    column(:service_name, :order => "services.name", header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.name + " (#{I18n.t("service_type_options.#{record.service_type}")})"
    end

    column(:overall_satisfaction, header: I18n.t('activerecord.attributes.dynamic_reports.overall_satisfaction')) do |record|
      elementos= record.service_surveys_reports.map(&:positive_overall_perception)
      unless elementos.blank?
        if (elementos.reduce(:+)/elementos.count).round(2) < 70
          (elementos.reduce(:+)/elementos.count).round(2).to_s + "%"
        else
          I18n.t('activerecord.attributes.dynamic_reports.not_qualified')
        end
      end
    end

  end
  class  ServiceStatusReport
    include Datagrid

    scope do
      Service.includes(:service_surveys).uniq
    end


    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.month.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.date_range'))

    filter(:dependency,
           :enum,
           :select => scope.select(:dependency).uniq.order(:dependency).map(&:dependency),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))

    filter(:administrative_unit, :enum, :select => scope.select(:administrative_unit).
                                   uniq.order(:administrative_unit).map(&:administrative_unit),
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),)

    filter(:cis,
           :enum,
           :select => scope.select(:cis).map{|a| a.cis}.flatten.uniq.map{|a| [Services.service_cis_label(a), a]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where("services.cis similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_name,
           :enum,
           :select => scope.select(:name).uniq.order(:name).map(&:name),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |value, scope, grid|

      scope.where("services.name similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_type,
           :enum,
           :select => scope.select(:service_type).uniq.order(:service_type).
               map{|a| ["#{I18n.t("service_type_options.#{a.service_type}")}", a.service_type]},
          :multiple => true,
          header: I18n.t('activerecord.attributes.dynamic_reports.service_type')) do |value, scope, grid|

      scope.where("services.service_type similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:status,
           :enum,
           :select => scope.select(:status).uniq.map(&:status),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.status')) do |value, scope, grid|

      scope.where("services.status similar to ? ", "(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))
    column(:date_start, order: "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end, order: "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:dependency, header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.dependency
    end
    column(:administrative_unit, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.administrative_unit
    end
    column(:cis, header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.cis.map do |cis_id|
        Services.service_cis_label(cis_id)
      end.join(";")
    end
    column(:service_name,order: "services.name", header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |record|
      record.name + " (#{I18n.t("service_type_options.#{record.service_type}")})"
    end
    column(:status, header: I18n.t('activerecord.attributes.dynamic_reports.status'))
  end

  class  ServicesAllInformationReport
    include Datagrid

    scope do
      Service.includes(:service_surveys).includes(:service_reports)
    end

    filter(:id,
           :enum,
           :select => scope.select(:id).uniq.order(:id).map(&:id),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    filter(:created_at,
           :date,
           :range => true,
           :default => proc { [1.month.ago.to_date, Date.today]},
           header: I18n.t('activerecord.attributes.dynamic_reports.date_range'))

    filter(:dependency,
           :enum,
           :select => scope.select(:dependency).uniq.order(:dependency).map(&:dependency),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.dependency'))

    filter(:administrative_unit, :enum, :select => scope.select(:administrative_unit).
                                   uniq.order(:administrative_unit).map(&:administrative_unit),
           :multiple => true, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit'),)

    filter(:cis,
           :enum,
           :select => scope.select(:cis).map{|a| a.cis}.flatten.uniq.map{|a| [Services.service_cis_label(a), a]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |value, scope, grid|

      scope.where("services.cis similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:service_name,
           :enum,
           :select => scope.select(:name).uniq.order(:name).map(&:name),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_name')) do |value, scope, grid|

      scope.where("services.name similar to ? ", "%(#{value.uniq.join("|")})%")
    end
    filter(:service_type,
           :enum,
           :select => scope.select(:service_type).uniq.order(:service_type).
               map{|a| ["#{I18n.t("service_type_options.#{a.service_type}")}", a.service_type]},
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.service_type')) do |value, scope, grid|

      scope.where("services.service_type similar to ? ", "%(#{value.uniq.join("|")})%")
    end

    filter(:status,
           :enum,
           :select => scope.select(:status).uniq.map(&:status),
           :multiple => true,
           header: I18n.t('activerecord.attributes.dynamic_reports.status')) do |value, scope, grid|

      scope.where("services.status similar to ? ", "(#{value.uniq.join("|")})%")
    end

    column(:id, header: I18n.t('activerecord.attributes.dynamic_reports.service_id'))

    column(:date_start, order: "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_start')) do |record|
      record.created_at.to_date - 3.days
    end
    column(:date_end, order: "services.created_at", header: I18n.t('activerecord.attributes.dynamic_reports.date_end')) do |record|
      record.created_at.to_date
    end
    column(:name, header: I18n.t('activerecord.attributes.dynamic_reports.name')) do |record|
      record.name
    end
    column(:service_type, :order => "services.name" , header: I18n.t('activerecord.attributes.dynamic_reports.service_type')) do |record|
      "(#{I18n.t("service_type_options.#{record.service_type}")})"
    end
    column(:dependency, header: I18n.t('activerecord.attributes.dynamic_reports.dependency')) do |record|
      record.dependency
    end
    column(:administrative_unit, header: I18n.t('activerecord.attributes.dynamic_reports.administrative_unit')) do |record|
      record.administrative_unit
    end
    column(:manager, header: I18n.t('activerecord.attributes.dynamic_reports.admins')) do |record|
      "#{record.service_admin.name} #{record.service_admin.surname}"
    end
    column(:admins, header: I18n.t('activerecord.attributes.dynamic_reports.public_servant')) do |record|
      record.admins.map{|a| "#{a.name} #{a.surname}" }.join("; ")
    end
    column(:cis, header: I18n.t('activerecord.attributes.dynamic_reports.cis')) do |record|
      record.cis.map do |cis_id|
        Services.service_cis_label(cis_id)
      end.join(";")
    end
    column(:title, header: I18n.t('activerecord.attributes.dynamic_reports.survey_titles')) do |record|
      record.service_surveys.map(&:title).join(";")
    end
    column(:people_who_participated, header: I18n.t('activerecord.attributes.dynamic_reports.people_who_participated'))  do |record|
      record.service_reports.map(&:respondents_count).reduce(:+)
    end
    column(:positive_overall_perception, header: I18n.t('activerecord.attributes.dynamic_reports.positive_overall_perception')) do |record|
      if record.service_reports.order(:created_at).map(&:positive_overall_perception).last
        "#{record.service_reports.order(:created_at).map(&:positive_overall_perception).last}%"
      else
        I18n.t('activerecord.attributes.dynamic_reports.not_evaluated')
      end
    end


    column(:areas_results, header: I18n.t("question_criterion_options.transparency")) do |record|
      if record.service_reports.order(:created_at).map{|a| a.overall_areas[:transparency]}.last
        """
          #{record.service_reports.order(:created_at).map{|a| a.overall_areas[:transparency]}.last.round(2)} %
        """
      end

    end


    column(:areas_results, header: I18n.t("question_criterion_options.performance")) do |record|
      if record.service_reports.order(:created_at).map{|a| a.overall_areas[:performance]}.last
        """
          #{record.service_reports.order(:created_at).map{|a| a.overall_areas[:performance]}.last.round(2)} %
        """
      else
        I18n.t('activerecord.attributes.dynamic_reports.not_evaluated')
      end

    end

    column(:areas_results, header: I18n.t("question_criterion_options.quality_service")) do |record|
      if record.service_reports.order(:created_at).map{|a| a.overall_areas[:quality_service]}.last
        """
          #{record.service_reports.order(:created_at).map{|a| a.overall_areas[:quality_service]}.last.round(2)} %
        """
      else
        I18n.t('activerecord.attributes.dynamic_reports.not_evaluated')
      end

    end

    column(:areas_results, header: I18n.t("question_criterion_options.accessibility")) do |record|
      if record.service_reports.order(:created_at).map{|a| a.overall_areas[:accessibility]}.last
        """
          #{record.service_reports.order(:created_at).map{|a| a.overall_areas[:accessibility]}.last.round(2)} %
        """
      else
        I18n.t('activerecord.attributes.dynamic_reports.not_evaluated')
      end

    end

    column(:areas_results, header: I18n.t("question_criterion_options.infrastructure")) do |record|
      if record.service_reports.order(:created_at).map{|a| a.overall_areas[:infrastructure]}.last
        """
          #{record.service_reports.order(:created_at).map{|a| a.overall_areas[:infrastructure]}.last.round(2)} %
        """
      else
        I18n.t('activerecord.attributes.dynamic_reports.not_evaluated')
      end

    end

    column(:areas_results, header: I18n.t("question_criterion_options.public_servant")) do |record|
      if record.service_reports.order(:created_at).map{|a| a.overall_areas[:public_servant]}.last
        """
          #{record.service_reports.order(:created_at).map{|a| a.overall_areas[:public_servant]}.last.round(2)} %
        """
      else
        I18n.t('activerecord.attributes.dynamic_reports.not_evaluated')
      end
    end

  end
end
