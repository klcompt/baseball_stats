require 'csv'

class StatParser

  def initialize(input_data)
    @input_data = input_data
  end

  # Ex. input contents:
  # playerID,yearID,teamID,G,AB,R,H,2B,3B,HR,RBI,SB,CS
  # aardsda01,2012,NYA,1,,,,,,,,,
  # aardsda01,2010,SEA,53,0,0,0,0,0,0,0,0,0
  # aardsda01,2009,SEA,73,0,0,0,0,0,0,0,0,0
  # aardsda01,2008,BOS,47,1,0,0,0,0,0,0,0,0
  def parse
    data = CSV.parse(@input_data)
    data.shift   # remove header row
    headers = [:player_key, :year, :team_id, :game, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, :runs_batted_in, :stolen_bases, :caught_stealing]
    data.map {|row| Hash[ *(headers.zip(row).flatten) ] }
  end

end
