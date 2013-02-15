class PlayerLoader

  def load(player_data)
    Player.destroy_all
    player_data.each do |player_params|
      Player.create(player_params)
    end
  end

end
