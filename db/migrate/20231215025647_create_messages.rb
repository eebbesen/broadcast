class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :content, null: false
      t.string :status, null: false
      t.datetime :sent_at
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
