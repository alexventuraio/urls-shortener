class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :original
      t.string :short
      t.string :title
      t.integer :clicks_count

      t.timestamps
    end
  end
end
