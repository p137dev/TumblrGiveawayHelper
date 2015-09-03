class CreateTumblrLinks < ActiveRecord::Migration
  def change
    create_table :tumblr_links do |t|
      t.text :giveawaylink

      t.timestamps null: false
    end
  end
end
