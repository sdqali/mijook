class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :url
      t.boolean :queued
      t.timestamps
    end
  end
end
