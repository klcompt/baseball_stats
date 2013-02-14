class CreateStats < ActiveRecord::Migration

  def change
    create_table :stats do |t|
      t.string :player_id
      t.integer :year
      t.string :team_id
      t.integer :game, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, :runs_batted_in, :stolen_bases, :caught_stealing
    end
  end

end
