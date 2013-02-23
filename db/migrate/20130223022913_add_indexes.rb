class AddIndexes < ActiveRecord::Migration
  def up
    add_index :players, :id
    add_index :players, :player_key
    add_index :stats, :player_id
    add_index :stats, :year
    add_index :stats, :team_id
  end

  def down
    drop_index :players, :id
    drop_index :players, :player_key
    drop_index :stats, :player_id
    drop_index :stats, :year
    drop_index :stats, :team_id
  end
end
