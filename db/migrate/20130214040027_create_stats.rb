class CreateStats < ActiveRecord::Migration

  def change
    create_table :stats do |t|
      t.integer :player_id
      t.integer :year
      t.string :team_id
      t.integer :game, :default => 0
      t.integer :at_bats, :default => 0
      t.integer :runs, :default => 0
      t.integer :hits, :default => 0
      t.integer :doubles, :default => 0
      t.integer :triples, :default => 0
      t.integer :home_runs, :default => 0
      t.integer :runs_batted_in, :default => 0
      t.integer :stolen_bases, :default => 0
      t.integer :caught_stealing, :default => 0
    end
  end

end
