class AddRecipientEmailToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :recipient_email, :string
  end
end
