require File.expand_path('config/environment')
require File.expand_path('lib/parsers/player_parser')
require File.expand_path('lib/parsers/stat_parser')
require File.expand_path('lib/loaders/player_loader')
require File.expand_path('lib/loaders/stat_loader')

class Stats < Thor

  desc "all", "produces reults for Most improved batting average, Slugging percentages, top 5 most improved fantasy players, triple crown winner"

  method_options :reload => :boolean, :player_file => :string, :stats_file => :string
  def all(home_run_pts = nil, rbi_pts = nil, stolen_bases_pts = nil, caught_stealing_pts = nil )

    puts "Computing all 4 stat categories" 

    if options[:reload]
      player_file = options[:player_file] || "default_player_file.csv"
      stats_file = options[:stats_file] || "default_stats_file.csv"

      puts "Using player file: #{player_file}; stats file: #{stats_file}"


      puts "initializing player data"
      player_src = File.open(player_file, "r")
      player_hashes = PlayerParser.new(player_src).parse
      player_loader = PlayerLoader.new
      player_loader.load(player_hashes)

      puts "initializing stats data"
      stat_src = File.open(stats_file, "r")
      stat_hashes = StatParser.new(stat_src).parse
      stat_loader = StatLoader.new
      stat_loader.load(stat_hashes)
    else
      puts "Using existing Player and Stat data"
    end

    # 1) Most improved batting average( hits / at-bats) from 2009 to 2010.  Only include players with at least 200 at-bats.
    puts "Most improved batting average details (from 2009 to 2010 with min at_bats of 200) :"
    most_improved_detail = Player.most_improved_batting_average(2009, 2010, 200) 
    puts "\timprovement: #{ most_improved_detail[:improvement] } batting_average: #{ most_improved_detail[:average] } player: #{ most_improved_detail[:player].name }"


    # 2) Slugging percentage for all players on the Oakland A's (teamID = OAK) in 2007. 
    puts "Slugging percentages for all Oakland A's player in 2007:"
    team_stats = Stat.for_team_and_year('OAK', 2007)
    team_stats.each do |item|
      puts "\tslugging percentage: #{ item.slugging_percentage } - player: #{ item.player.name }"
    end


    # 3) Using the fantasy scoring below, identify the top 5 most improved fantasy players from 2011 to 2012.  Only include players with at least 500 at-bats.  The most improved players are those with the largest gains between 2011 fantasy points and 2012 fantasy points.
    puts "Top 5 most improved fantasy players from 2011 to 2012 with at least 500 at-bats:"

    if home_run_pts && rbi_pts && stolen_bases_pts && caught_stealing_pts 
      formula = { home_run_pts: home_run_pts.to_i, rbi_pts: rbi_pts.to_i, stolen_bases_pts: stolen_bases_pts.to_i, caught_stealing_pts: caught_stealing_pts.to_i }
    else
      formula = { home_run_pts: 4, rbi_pts: 1, stolen_bases_pts: 1, caught_stealing_pts: 1 }
    end
    puts "\tUsing formula #{ formula };"

    players = Player.for_year(2011)
    players = players.select do |player|
      player.has_min_at_bats?(2011, 500) && player.has_min_at_bats?(2012, 500)
    end
    most_improved = players.map do |p| 
      {improvement: ( p.fantasy_points(2012, formula) - p.fantasy_points(2011, formula) ), player: p} 
    end.sort_by {|data| data[:improvement] }.reverse.take(5)
    most_improved.each do |data|
      puts "\timprovement: #{ data[:improvement] } - player: #{ data[:player].name }"
    end

    # 4) Who won the triple crown winner in 2011 and 2012.  If no one won the crown, output "(No winner)"
    puts "Triple crown winner – The player that had the highest batting average AND the most home runs AND the most RBI. WITH NO MIN AT BATS"
    player = Player.triple_crown_winner(2011)
    puts "\tWinner for 2011 - #{ player.nil? ? "(No winner)" : player.name }"

    player = Player.triple_crown_winner(2012)
    puts "\tWinner for 2012 - #{ player.nil? ? "(No winner)" : player.name }"

    puts "Triple crown winner – The player that had the highest batting average AND the most home runs AND the most RBI. WITH 500 MIN AT BATS"
    player = Player.triple_crown_winner(2011, 500)
    puts "\tWinner for 2011 - #{ player.nil? ? "(No winner)" : player.name }"

    player = Player.triple_crown_winner(2012, 500)
    puts "\tWinner for 2012 - #{ player.nil? ? "(No winner)" : player.name }"

    puts "Triple crown winner – The player that had the highest batting average AND the most home runs AND the most RBI. WITH 500 MIN AT BATS AND NOT NAMED 'Posey' :-) "

    player = Player.triple_crown_winner(2011, 500, 'Posey')
    puts "\tWinner for 2011 - #{ player.nil? ? "(No winner)" : player.name }"

    player = Player.triple_crown_winner(2012, 500, 'Posey')
    puts "\tWinner for 2012 - #{ player.nil? ? "(No winner)" : player.name }"

  end
end
