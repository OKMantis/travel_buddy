class CreateActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :activities do |t|
      t.string :city
      t.string :category
      t.string :month
      t.text :content

      t.timestamps
    end
  end
end
