class UserEntity < Grape::Entity
        
  expose :id
  expose :username
  expose :email
  expose :firstname
  expose :lastname
  expose :admin
  expose :editor
  expose :organization_ids
  expose :group_ids
  expose :superuser
  expose :suspended
  expose :role_name
  expose :locale

  expose :settings

  expose :created_at
  expose :updated_at
  expose :last_login_at
  expose :last_request_at

end
