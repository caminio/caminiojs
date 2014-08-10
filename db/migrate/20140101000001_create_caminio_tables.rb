class CreateCaminioTables < ActiveRecord::Migration
  def change

    create_table :users do |t|

      t.string        :username
      t.string        :firstname
      t.string        :lastname
      t.string        :email, required: true
      t.string        :phone
      t.string        :categories
      t.string        :locale, required: true

      t.datetime      :last_login_at
      t.datetime      :last_request_at
      t.string        :last_login_ip

      t.string        :password_digest

      t.string        :confirmation_key
      t.datetime      :confirmation_key_expires_at

      t.string        :public_key
      t.string        :private_key

      t.string        :street
      t.string        :zip
      t.string        :country
      t.string        :county
      t.string        :city

      t.boolean       :api_user, default: false
      t.text          :settings

      t.datetime      :expires_at
  
      t.attachment    :avatar
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :categories
    add_index :users, :public_key, unique: true
    add_index :users, :private_key, unique: true

    create_table :organizational_unit_members do |t|
      t.integer       :user_id
      t.integer       :organizational_unit_id
      t.timestamps
    end
    add_index :organizational_unit_members, :user_id
    add_index :organizational_unit_members, :organizational_unit_id

    create_table :organizational_unit_app_plans do |t|
      t.integer       :app_plan_id
      t.integer       :organizational_unit_id
    end
    add_index :organizational_unit_app_plans, :app_plan_id
    add_index :organizational_unit_app_plans, :organizational_unit_id

    create_table :app_plans do |t|
      t.string        :name
      t.integer       :price
      t.integer       :app_id
      t.integer       :user_quota, default: 1
      t.integer       :disk_quota, default: 0
      t.integer       :content_quota, default: 0
      t.boolean       :visible, default: false
      t.datetime        :deleted_at
      t.integer         :deleted_by
      t.timestamps
    end
    add_index :app_plans, :app_id #, unique: true
    add_index :app_plans, :name, unique: true

    create_table :translations do |t|
      t.integer         :row_id
      t.string          :row_type
      t.string          :locale
      t.string          :title
      t.string          :subtitle
      t.text            :aside
      t.text            :aside2
      t.text            :aside3
      t.text            :content
      t.text            :description
      t.string          :keywords
      t.integer         :created_by
      t.integer         :updated_by
      t.timestamps
    end

    create_table :app_models do |t|
      t.string          :name
      t.integer         :app_id
      t.string          :icon
      t.string          :path
      t.boolean         :hidden, default: false
      t.boolean         :always, default: false 
    end

    create_table :app_model_user_roles do |t|
      t.integer         :user_id
      t.integer         :app_model_id
      t.integer         :organizational_unit_id
      t.string          :access_level
    end
    add_index :app_model_user_roles, :user_id
    add_index :app_model_user_roles, :app_model_id

    create_table :apps do |t|
      t.string          :name
      t.integer         :position
      t.boolean         :is_public, default: false
    end
    add_index :apps, :name, unique: true

    create_table :organizational_units do |t|

      t.string        :name
      t.integer       :owner_id
      t.boolean       :suspended
      t.string        :color
      t.text          :settings
      t.integer       :created_by
      t.integer       :updated_by
      t.timestamps

    end

    create_table :messages do |t|

      t.string          :title
      t.text            :content
      t.integer         :parent_id
      t.integer         :row_id
      t.string          :row_type
      t.string          :type 
      t.boolean         :important
      t.caminio_row
      t.timestamps

    end
    add_index :messages, :parent_id
    add_index :messages, :created_by

    create_table :user_messages do |t|

      t.integer         :user_id
      t.integer         :message_id
      t.boolean         :read, default: false

    end
    add_index :user_messages, :user_id
    add_index :user_messages, :message_id

    create_table :message_labels do |t|

      t.integer         :message_id
      t.integer         :label_id

    end
    add_index :message_labels, :label_id
    add_index :message_labels, :message_id

    create_table :api_keys do |t|
      t.references    :user
      t.string        :access_token
      t.datetime      :expires_at
    end
    add_index :api_keys, :user_id, unique: true

    create_table :labels do |t|
      t.string          :name
      t.string          :color
      t.integer         :created_by
      t.integer         :updated_by
      t.datetime        :deleted_at
      t.integer         :deleted_by
      t.timestamps
    end
    add_index :labels, :name

    create_table :row_labels do |t|
      t.references      :label
      t.integer         :row_id
      t.string          :row_type
    end
    add_index :row_labels, :row_id
    add_index :row_labels, :row_type

    create_table :access_rules do |t|
      t.integer       :row_id
      t.string        :row_type
      t.integer       :group_id
      t.integer       :organizational_unit_id
      t.references    :label
      t.references    :user
      t.boolean       :can_write, default: false
      t.boolean       :can_share, default: false
      t.boolean       :can_delete, default: false
      t.boolean       :is_owner, default: false
      t.integer       :created_by
      t.integer       :updated_by
      t.timestamps
    end
    add_index :access_rules, :user_id
    add_index :access_rules, :row_id
    add_index :access_rules, :row_type
    add_index :access_rules, :organizational_unit_id

  end
end
