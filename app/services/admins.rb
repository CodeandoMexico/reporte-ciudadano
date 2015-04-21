module Admins
  def self.permissions_for_admin(admin)
    Permissions.new(admin)
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
      admin.service_id == service.id
    end
  end
end