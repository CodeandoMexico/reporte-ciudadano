module Admins
  def self.permissions_for_admin(admin)
    Permissions.new(admin)
  end

  def self.service_requests_for(admin, params)
    if admin.is_super_admin?
      ServiceRequest.filter_by_search(params)
    elsif admin.is_service_admin?
      admin.managed_service_requests
    else admin.is_public_servant?
      admin.assigned_service_requests
    end
  end

  class Permissions
    def initialize(admin)
      @admin = admin
    end

    def can_manage_service_admins?
      is_super_admin?(admin)
    end

    def can_manage_service_requests?(service)
      is_super_admin?(admin) ||
        (admin.is_service_admin? && is_managing_service?(service)) ||
        (admin.is_public_servant? && has_service_assigned?(service))
    end

    def is_super_admin?(admin)
      !(admin.is_service_admin? || admin.is_public_servant?)
    end

    private

    attr_reader :admin

    def is_managing_service?(service)
      admin.services_ids.include?(service.id)
    end

    def has_service_assigned?(service)
      Services.is_assigned_to_public_servant?(service, admin)
    end
  end
end