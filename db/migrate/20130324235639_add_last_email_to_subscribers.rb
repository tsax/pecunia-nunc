class AddLastEmailToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :last_email, :datetime
  end
end
