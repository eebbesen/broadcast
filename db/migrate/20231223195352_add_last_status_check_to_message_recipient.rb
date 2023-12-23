class AddLastStatusCheckToMessageRecipient < ActiveRecord::Migration[7.1]
  def change
    add_column :message_recipients, :last_status_check, :datetime
  end
end
