class AddTitleToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column "tickets", "title", :string
  end
end
