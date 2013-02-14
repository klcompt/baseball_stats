class PlayerLoader

  def load(player_data)
    player_data.each do |player_params|
      Player.create(player_params)
    end
  end

end
