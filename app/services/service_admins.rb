module ServiceAdmins
  def self.permissions_for_admin(admin)
    Permissions.new(admin)
  end

  class Permissions
    def initialize(admin)
      @admin = admin
    end

    def can_manage_service_admins?
      !admin.is_service_admin
    end

    private

    attr_reader :admin
  end
end