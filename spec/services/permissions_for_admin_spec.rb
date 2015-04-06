require 'spec_helper'
require_relative '../../app/services/service_admins'

module ServiceAdmins
  describe 'Permissions for user' do
    describe 'can_manage_service_admin' do
      it 'unless is not a super admin' do
        admin = double :admin, is_service_admin: true
        permissions = permissions_for_user(admin)
        expect(permissions.can_manage_service_admins?).not_to be
      end

      it 'if is a super admin' do
        admin = double :admin, is_service_admin: false
        permissions = permissions_for_user(admin)
        expect(permissions.can_manage_service_admins?).to be
      end
    end

    def permissions_for_user(admin)
      ServiceAdmins.permissions_for_admin(admin)
    end
  end
end