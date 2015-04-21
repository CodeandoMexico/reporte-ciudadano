require 'spec_helper'
require_relative '../../app/services/admins'

module ServiceAdmins
  describe 'Permissions for user' do
    describe 'can_manage_service_admin' do
      it 'unless is not a super admin' do
        admin = double :admin, is_service_admin?: true, is_public_servant?: false
        permissions = permissions_for_user(admin)
        expect(permissions.can_manage_service_admins?).not_to be
      end

      it 'if is a super admin' do
        admin = double :admin, is_service_admin?: false, is_public_servant?: false
        permissions = permissions_for_user(admin)
        expect(permissions.can_manage_service_admins?).to be
      end
    end

    describe 'can_manage_service_requests' do
      it 'if service admin and is managing the service' do
        service = double :service, id: 'service-id'
        admin = double :admin, is_service_admin?: true, is_public_servant?: false, services_ids: ['service-id']
        permissions = permissions_for_user(admin)
        expect(permissions.can_manage_service_requests?(service)).to be
      end

      it 'if public servant and has been assigned to service' do
        service = double :service, id: 'service-id'
        admin = double :admin, is_service_admin?: false, is_public_servant?: true, service_id: 'service-id'
        permissions = permissions_for_user(admin)
        expect(permissions.can_manage_service_requests?(service)).to be
      end

      it 'if is a super admin' do
        service = double :service, id: 'service-id'
        admin = double :admin, is_service_admin?: false, is_public_servant?: false
        permissions = permissions_for_user(admin)
        expect(permissions.can_manage_service_requests?(service)).to be
      end

      it 'unless service admin and is NOT managing the service' do
        service = double :service, id: 'service-id'
        admin = double :admin, is_service_admin?: true, is_public_servant?: false, services_ids: ['other-service-id']
        permissions = permissions_for_user(admin)
        expect(permissions.can_manage_service_requests?(service)).not_to be
      end

      it 'unless public servant and has NOT been assigned to service' do
        service = double :service, id: 'service-id'
        admin = double :admin, is_service_admin?: false, is_public_servant?: true, service_id: 'other-service-id'
        permissions = permissions_for_user(admin)
        expect(permissions.can_manage_service_requests?(service)).not_to be
      end
    end

    def permissions_for_user(admin)
      Admins.permissions_for_admin(admin)
    end
  end
end