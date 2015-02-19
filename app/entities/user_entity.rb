class UserEntity < Grape::Entity
        
  expose :id
  expose :username
  expose :email
  expose :firstname
  expose :lastname
  expose :admin
  expose :editor
  expose :organization_ids
  expose :organization_id
  expose :group_ids
  expose :superuser
  expose :suspended
  expose :role_name
  expose :locale
  expose :completed_tours

  expose :settings

  expose :created_at
  expose :updated_at
  expose :last_login_at
  expose :last_request_at

  def organization_id
    RequestStore::store['organization_id']
  end

end
