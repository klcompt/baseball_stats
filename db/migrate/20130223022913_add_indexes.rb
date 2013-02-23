class AddIndexes < ActiveRecord::Migration
  def change
    add_index :players, :id
    add_index :players, :player_key
    add_index :stats, :player_id
    add_index :stats, :year
    add_index :stats, :team_id
  end
end
