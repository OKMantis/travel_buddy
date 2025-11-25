class RenameMonthToSeasonInActivities < ActiveRecord::Migration[7.2]
  def change
    rename_column :activities, :month, :season
  end
end
