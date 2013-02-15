class CreatePlayers < ActiveRecord::Migration

  def change
    create_table :players do |t|
      t.string :player_key
      t.integer :birth_year
      t.string :last_name
      t.string :first_name
    end
  end

end
