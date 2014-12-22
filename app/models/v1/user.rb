module V1
  class User < ActiveRecord::Base
    has_secure_password
    has_one :api_key, dependent: :delete
    has_and_belongs_to_many :organizations

    before_create :create_membership_for_organization
    before_validation :set_password_if_blank

    attr_accessor :organization_id

    def aquire_api_key
      ApiKey.where( user_id: id ).delete_all
      create_api_key
    end

    def is_admin?
      role == 'admin'
    end

    def use_organization(org_id)
      org_id = (org_id.is_a?(Integer) ? org_id : org.id )
      RequestStore.store[:organization_id] = org_id
    end

    private

    def create_membership_for_organization
      if organization = Organization.find_by( id: organization_id )
        organizations << organization
        return
      elsif org_id = RequestStore.store[:organization_id]
        organizations << Organization.find( org_id )
      end
    end

    def set_password_if_blank
      return unless password_digest.blank? || password.blank?
      self.password = SecureRandom.hex(8).to_s
    end

  end

end