require 'spec_helper'
require_relative '../../app/services/admins'

module Admins
  class TestAdmin
    attr_accessor :is_service_admin, :is_public_servant, :dependency

    def initialize(attrs)
      @is_service_admin = attrs[:is_service_admin]
      @dependency = attrs[:dependency]
    end

    def is_super_admin?
      !(is_service_admin || is_public_servant)
    end

    def is_service_admin?
      is_service_admin
    end

    def is_public_servant?
      is_public_servant
    end
  end

  describe 'public servants for admin' do
    it 'returns the public servants with same dependency as service admin' do
      admin = TestAdmin.new(is_public_servant: false, is_service_admin: true, dependency: 'dependency')
      expect(Admin).to receive(:public_servants_by_dependency).with('dependency')
      public_servants_for(admin)
    end

    it 'returns all the public servants when is super admin' do
      admin = TestAdmin.new(is_service_admin: false, is_public_servant: false)
      expect(Admin).not_to receive(:public_servants_by_dependency).with('dependency')
      expect(Admin).to receive(:public_servants_sorted_by_name)
      public_servants_for(admin)
    end

    def public_servants_for(admin)
      Admins.public_servants_for(admin)
    end
  end

  describe 'disabled public servants for admin' do
    it 'returns the public servants with same dependency as service admin' do
      admin = TestAdmin.new(is_public_servant: false, is_service_admin: true, dependency: 'dependency')
      expect(Admin).to receive(:disabled_public_servants_by_dependency).with('dependency')
      disabled_public_servants_for(admin)
    end

    it 'returns all the public servants when is super admin' do
      admin = TestAdmin.new(is_service_admin: false, is_public_servant: false)
      expect(Admin).not_to receive(:disabled_public_servants_by_dependency).with('dependency')
      expect(Admin).to receive(:disabled_public_servants_sorted_by_name)
      disabled_public_servants_for(admin)
    end

    def disabled_public_servants_for(admin)
      Admins.disabled_public_servants_for(admin)
    end
  end
end