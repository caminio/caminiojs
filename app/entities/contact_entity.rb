class ContactEntity < Grape::Entity
        
  expose :id

  expose :organization
  expose :firstname
  expose :lastname

  expose :degree
  expose :gender
  expose :email
  expose :phone

  expose :created_at
  expose :updated_at

end
