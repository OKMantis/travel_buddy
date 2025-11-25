class RenameMonthToSeasonInActivities < ActiveRecord::Migration[7.2]
  def change
    rename_column :activities, :month, :season
    add_column :activities, :link, :string
  end
end
