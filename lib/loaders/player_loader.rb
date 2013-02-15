class PlayerLoader

  def load(player_data)
    Player.delete_all
    player_data.each do |player_params|
      Player.create(player_params)
    end
  end

end
