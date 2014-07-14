class CreateCaminioTables < ActiveRecord::Migration
  def change

    create_table :users do |t|

      t.string        :nickname
      t.string        :firstname
      t.string        :lastname
      t.string        :email, required: true
      t.string        :phone
      t.string        :categories

      t.integer       :access_level, default: 50
      t.boolean       :suspended, default: false
      t.boolean       :superuser, default: false

      t.datetime      :last_login_at
      t.datetime      :last_request_at
      t.string        :last_login_ip
      t.text          :app_ids

      t.string        :password_digest

      t.string        :confirmation_key
      t.datetime      :confirmation_key_expires_at

      t.string        :public_key
      t.string        :private_key

      t.boolean       :api_user, default: false
      t.text          :settings

      t.datetime      :expires_at

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :categories
    add_index :users, :public_key, unique: true
    add_index :users, :private_key, unique: true

    create_table :domains do |t|

      t.string        :name
      t.string        :qualified_name

      t.integer       :role, default: 50
      t.boolean       :suspended, default: false
      t.boolean       :superuser, default: false

      t.datetime      :last_login_at
      t.datetime      :last_request_at
      t.string        :last_login_ip

      t.text          :app_ids

      t.string        :password_digest

      t.text          :settings

      t.timestamps
    end

    add_index :domains, :name, unique: true
    add_index :domains, :qualified_name, unique: true

    create_table :circles do |t|
      t.references    :user
      t.boolean       :follow, default: false
      t.text          :settings
      t.timestamps
    end

    add_index :circles, :user_id

    create_table :subscriptions do |t|

      t.string        :obj_type
      t.integer       :obj_id

      t.timestamps
    end
    add_index :subscriptions, :obj_id

    create_table :api_keys do |t|
      t.references    :user
      t.string        :access_token
      t.datetime      :expires_at
    end

  end
end
