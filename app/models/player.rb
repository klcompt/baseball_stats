class Player < ActiveRecord::Base
  has_many :stats

  scope :for_year, lambda { |year| select('distinct players.*').joins(:stats).merge( Stat.for_year(year) ) }


  def self.most_improved_batting_average(year1, year2, min_at_bats)
    players = find_all_that_played_both_years(year1, year2)

    players = players.select do |player| 
      player.has_min_at_bats?(year1, min_at_bats) && 
        player.has_min_at_bats?(year2, min_at_bats)
    end

    most_improved_player = nil
    most_improved_average = 0.0
    most_improvement = 0.0

    players.each do |player|
      improvement = player.batting_avg_improvement(year1, year2)

      if most_improvement < improvement
        most_improvement = improvement
        most_improved_average = player.batting_avg(year2)
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
    sum_stat(year, :hits)
  end

  def has_min_at_bats?(year, min)
    at_bat_count(year) >= min
  end

  def at_bat_count(year)
    sum_stat(year, :at_bats)
  end

  def sum_stat(year, field)
    stats.for_year(year).sum(field)
  end

end
