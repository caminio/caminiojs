class CreateOrganizations < ActiveRecord::Migration

  def up

    create_table :organizations do |t|
      t.string    :name, index: true
      t.timestamps
    end

    create_table :organizations_users, id: false do |t|
      t.references :user, :organization
    end

  end 

  def down
    drop_table :organizations, :organizations_users
  end

end
