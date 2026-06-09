class CreateSystemSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :system_settings, id: :uuid do |t|
      t.string :category, null: false
      t.jsonb :settings, default: {}, null: false

      t.timestamps
    end
    add_index :system_settings, :category, unique: true
  end
end
