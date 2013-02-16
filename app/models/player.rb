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

  def self.triple_crown_winner(year, min_at_bats = nil)
    players = for_year(year)
    if min_at_bats
      players = players.select {|player| player.has_min_at_bats?(year, min_at_bats) }
    end

    players_with_batting_avg = players.map { |player| { batting_avg: player.batting_avg(year), player: player } }
    max_batting_avg = players_with_batting_avg.max_by { |entry| entry[:batting_avg] }[:batting_avg]
    players_that_have_highest_batting_avg = players_with_batting_avg.select { |data| data[:batting_avg] == max_batting_avg }

    players_with_home_run_count = players.map { |player| { home_runs: player.home_runs(year), player: player } }
    max_home_runs = players_with_home_run_count.max_by { |entry| entry[:home_runs] }[:home_runs]
    players_that_have_most_home_runs = players_with_home_run_count.select { |data| data[:home_runs] == max_home_runs }

    players_with_rbis = players.map { |player| { rbis: player.runs_batted_in(year), player: player } }
    max_rbis = players_with_rbis.max_by { |entry| entry[:rbis] }[:rbis]
    players_that_have_most_rbis = players_with_rbis.select { |data| data[:rbis] == max_rbis }

    # find intersection between all players
    player_matches = players_that_have_highest_batting_avg.map {|entry| entry[:player] } &
                     players_that_have_most_home_runs.map {|entry| entry[:player] } &
                     players_that_have_most_rbis.map {|entry| entry[:player] }
    if player_matches.empty?
      nil
    else
      player_matches[0]
    end
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
