class StatLoader

  def load(stat_data)
    Stat.destroy_all
    stat_data.each do |stat_params|
      Stat.create(stat_params)
    end
  end

end
