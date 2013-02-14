class StatLoader

  def load(stat_data)
    stat_data.each do |stat_params|
      Stat.create(stat_params)
    end
  end

end
