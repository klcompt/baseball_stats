require File.expand_path('config/environment')
require File.expand_path('lib/parsers/player_parser')
require File.expand_path('lib/parsers/stat_parser')
require File.expand_path('lib/loaders/player_loader')
require File.expand_path('lib/loaders/stat_loader')

class Stats < Thor

  desc "all", "produces reults for Most improved batting average, Slugging percentages, top 5 most improved fantasy players, triple crown winner"

  method_options :reload => :boolean, :player_file => :string, :stats_file => :string, :fantasy_points => :hash
  def all
    puts "Computing all 4 stat categories" 

    if options[:reload]
      player_file = options[:player_file] || "default_player_file.csv"
      stats_file = options[:stats_file] || "default_stats_file.csv"
      fantasy_file = options[:fantasy_file] || { home_run_pts: 4, rbi_points: 1, stolen_bases_pts: 1, caught_stealing_pts: 1 } 

      puts "Using player file: #{player_file}; stats file: #{stats_file}, fantasy point values: #{fantasy_file}"


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
    puts "Most improved batting average details: #{ Player.most_improved_batting_average(2009, 2010, 200) }"

    # 2) Slugging percentage for all players on the Oakland A's (teamID = OAK) in 2007. 
    #puts "Slugging percentages for all Oakland A's player in 2007:"
    #slugging_percentage_data = Player.slugging_percentages('OAK', 2007)
    #slugging_percentage_data.each do |percentage_data|
    #  puts percentage_data
    #end

    # 3) Using the fantasy scoring below, identify the top 5 most improved fantasy players from 2011 to 2012.  Only include players with at least 500 at-bats.  The most improved players are those with the largest gains between 2011 fantasy points and 2012 fantasy points.
    # 4) Who won the triple crown winner in 2011 and 2012.  If no one won the crown, output "(No winner)"

  end
end
