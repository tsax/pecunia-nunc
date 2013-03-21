class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :name
      t.string :email
      t.string :token
      t.boolean :active

      t.timestamps
    end
  end
end
