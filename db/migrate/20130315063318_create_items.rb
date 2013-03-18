class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.text :description
      t.datetime :pub_date
      t.string :link
      t.string :guid
      t.boolean :read, :default => false
      t.integer :feed_id

      t.timestamps
    end
  end
end
