class CreateUsers < ActiveRecord::Migration

  def up
    create_table :users do |t|
      t.string    :username, index: true
      t.string    :firstname
      t.string    :lastname
      t.string    :email, index: true
      t.string    :password_digest
      t.string    :role, default: 'user'
      t.string    :locale, default: I18n.default_locale
      t.datetime  :valid_until
      t.timestamps
    end

  end 

  def down
    drop_table :users
  end

end
