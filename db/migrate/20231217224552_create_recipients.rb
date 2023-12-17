# frozen_string_literal: true

class CreateRecipients < ActiveRecord::Migration[7.1]
  def change
    create_table :recipients do |t|
      t.string :phone, null: false, unique: true
      t.string :status, null: false

      t.timestamps
    end
  end
end
