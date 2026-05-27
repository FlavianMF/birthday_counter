class AddGameConfigToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :game_config, :jsonb
  end
end
