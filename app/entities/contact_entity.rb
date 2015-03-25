class ContactEntity < Grape::Entity
        
  expose :id

  expose :company
  expose :firstname
  expose :lastname

  expose :degree
  expose :gender
  expose :email
  expose :phone

  expose :created_at
  expose :updated_at

end
