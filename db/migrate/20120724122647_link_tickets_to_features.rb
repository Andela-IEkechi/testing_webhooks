class LinkTicketsToFeatures < ActiveRecord::Migration
  def change
  	change_table :tickets do |t| 
  		t.references :feature
  	end
  end
end
