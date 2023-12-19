# frozen_string_literal: true

class CreateMessageRecipients < ActiveRecord::Migration[7.1]
  def change
    create_table :message_recipients do |t|
      t.string :status, null: false
      t.string :error
      t.string :sid
      t.references :message, null: false, foreign_key: true
      t.references :recipient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
