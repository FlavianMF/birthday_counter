class AllowNullHostIdOnEvents < ActiveRecord::Migration[7.1]
  def change
    change_column_null :events, :host_id, true
  end
end
