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

  expose :created_at
  expose :updated_at
  expose :last_login_at

end
