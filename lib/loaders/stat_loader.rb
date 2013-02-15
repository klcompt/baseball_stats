class StatLoader
  COUNT_FIELDS = [ :game, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, 
                      :runs_batted_in, :stolen_bases, :caught_stealing ]
  def load(stat_data)
    Stat.destroy_all
    stat_data.each do |stat_params|
      if player = Player.find_by_player_key(stat_params.delete(:player_key))
        zero_out_empty_count_fields(stat_params)
        player.stats << Stat.new(stat_params)
        player.save
      end
    end
  end

  private

  def zero_out_empty_count_fields(params)
    COUNT_FIELDS.each do |key|
      params[key] = 0 if params[key].blank?
    end 
  end

end
