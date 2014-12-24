class CreateApiKeys < ActiveRecord::Migration

  def up
    create_table :api_keys do |t|
      t.string      :token
      t.datetime    :expires_at
      t.references  :user
      t.timestamps
    end
  end 

  def down
    drop_table :api_keys
  end

end
