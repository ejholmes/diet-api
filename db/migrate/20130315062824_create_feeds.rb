class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :xml_url
      t.string :html_url
      t.text :text
      t.string :title

      t.timestamps
    end
  end
end
