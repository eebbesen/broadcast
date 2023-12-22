# frozen_string_literal: true

class CreateMessageRecipientLists < ActiveRecord::Migration[7.1]
  def change
    create_table :message_recipient_lists do |t|
      t.references :message, null: false, foreign_key: true
      t.references :recipient_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
