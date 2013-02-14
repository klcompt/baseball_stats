require 'spec_helper'

describe Stat do
  it 'accepts intialization params' do
    stat = Stat.new(player_id: 'compton01', year: 2010, team_id: 'Cardinals', 
                  game: 12, at_bats: 32, runs: 4, hits: 23, doubles: 3, triples: 10, 
                  home_runs: 1, runs_batted_in: 8, stolen_bases: 3, caught_stealing: 2)

    stat.player_id.should == 'compton01'
    stat.year.should == 2010
    stat.team_id.should == 'Cardinals'
    stat.game.should == 12 
    stat.at_bats.should == 32
    stat.runs.should == 4
    stat.hits.should == 23
    stat.doubles.should == 3
    stat.triples.should == 10
    stat.home_runs.should == 1
    stat.runs_batted_in.should == 8
    stat.stolen_bases.should == 3
    stat.caught_stealing.should == 2
  end
end
