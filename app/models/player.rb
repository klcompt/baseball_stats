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

  def self.triple_crown_winner(year, min_at_bats = nil, exclude_last_name = nil)
    players = for_year(year)
    if min_at_bats
      players = players.select { |player| player.has_min_at_bats?(year, min_at_bats) }
    end
    if exclude_last_name
      players = players.reject { |player| player.last_name == 'Posey' }
    end

    player_matches = players_with_highest_batting_avg(players, year) & 
                     players_that_have_most_home_runs(players, year) &
                     players_that_have_most_rbis(players, year)

    if player_matches.empty?
      nil
    else
      player_matches[0]
    end
  end

  def self.players_with_highest_batting_avg(players, year)
    players.group_by { |player| player.batting_avg(year) }.max[1]
  end

  def self.players_that_have_most_home_runs(players, year)
    players.group_by { |player| player.home_runs(year) }.max[1]
  end

  def self.players_that_have_most_rbis(players, year)
    players.group_by { |player| player.runs_batted_in(year) }.max[1]
  end

  def fantasy_points(year, formula)
    stats.for_year(year).fantasy_points(formula)
  end

  def name
    "#{last_name}, #{first_name}"
  end

  def batting_avg_improvement(year1, year2)
    batting_avg(year2) - batting_avg(year1)
  end

  def batting_avg(year)
    at_bats = at_bats(year)
    if at_bats == 0 
      0.0
    else
      hits(year) / at_bats.to_f
    end
  end

  def home_runs(year)
    sum_stat(year, :home_runs)
  end

  def runs_batted_in(year)
    sum_stat(year, :runs_batted_in)
  end

  def hits(year)
    sum_stat(year, :hits)
  end

  def has_min_at_bats?(year, min)
    at_bats(year) >= min
  end

  def at_bats(year)
    sum_stat(year, :at_bats)
  end

  def sum_stat(year, field)
    stats.for_year(year).sum(field)
  end

end
