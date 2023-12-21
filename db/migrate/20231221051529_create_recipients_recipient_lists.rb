# frozen_string_literal: true

class CreateRecipientsRecipientLists < ActiveRecord::Migration[7.1]
  def change
    create_table :recipients_recipient_lists do |t|
      t.references :recipient, null: false, foreign_key: true
      t.references :recipient_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
