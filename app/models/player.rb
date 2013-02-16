class Player < ActiveRecord::Base
  has_many :stats

  scope :ordered_by_player_key, order( :player_key )

  scope :for_year, lambda { |year| select('distinct players.*').joins(:stats).merge( Stat.for_year(year) ) }

  def self.most_improved_batting_average(from_year, to_year, min_at_bats)
    players = find_all_that_played_both_years(from_year, to_year)

    players = players.select do |player| 
      player.has_min_at_bats?(from_year, min_at_bats) && 
        player.has_min_at_bats?(to_year, min_at_bats)
    end

    most_improved_player = nil
    most_improved_average = 0.0
    most_improvement = 0.0

    players.each do |player|
      avg_year1 = player.batting_avg(from_year)
      avg_year2 = player.batting_avg(to_year)
      improvement = player.batting_avg_improvement(from_year, to_year)

      if most_improvement < improvement
        most_improvement = improvement
        most_improved_average = avg_year2
        most_improved_player = player
      end
    end

    return { improvement: most_improvement, average: most_improved_average, player: most_improved_player }
  end

  def self.find_all_that_played_both_years(year1, year2)
    for_year(year1) & for_year(year2)
  end

  def batting_avg_improvement(year1, year2)
    batting_avg(year2) - batting_avg(year1)
  end

  def batting_avg(year)
    at_bats = at_bat_count(year)
    if at_bats == 0 
      0.0
    else
      hits(year) / at_bats.to_f
    end
  end

  def hits(year)
    stats.for_year(year).sum(:hits)
  end

  def has_min_at_bats?(year, min)
    at_bat_count(year) >= min
  end

  def at_bat_count(year)
    stats.for_year(year).sum(:at_bats)
  end

end
