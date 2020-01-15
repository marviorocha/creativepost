class CreatePartituras < ActiveRecord::Migration[6.0]
  def change
    create_table :partituras do |t|
      t.string :title
      t.string :link
      t.string :description
      t.string :image

      t.timestamps
    end
  end
end
