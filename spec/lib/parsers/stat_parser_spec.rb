require 'spec_helper'
require './lib/parsers/stat_parser'

describe 'StatParser' do

  it 'parses input correctly' do
    io = "playerID,yearID,teamID,G,AB,R,H,2B,3B,HR,RBI,SB,CS\naardsda01,2012,NYA,1,,,,,,,,,\naardsda01,2008,BOS,47,1,2,3,4,5,6,7,8,9\n"

    parser = StatParser.new(io)
    stat_hash = parser.parse

    stat_hash[0][:player_id].should == 'aardsda01'
    stat_hash[0][:year].should == '2012' 
    stat_hash[0][:team_id].should == 'NYA'
    stat_hash[0][:game].should == '1'
    stat_hash[0][:at_bats].should be_nil 
    stat_hash[0][:runs].should be_nil 
    stat_hash[0][:hits].should be_nil 
    stat_hash[0][:doubles].should be_nil 
    stat_hash[0][:triples].should be_nil 
    stat_hash[0][:home_runs].should be_nil
    stat_hash[0][:runs_batted_in].should be_nil 
    stat_hash[0][:stolen_bases].should be_nil
    stat_hash[0][:caught_stealing].should be_nil 

    stat_hash[1][:player_id].should == 'aardsda01'
    stat_hash[1][:year].should == '2008' 
    stat_hash[1][:team_id].should == 'BOS'
    stat_hash[1][:game].should == '47'
    stat_hash[1][:at_bats].should == '1'
    stat_hash[1][:runs].should == '2'
    stat_hash[1][:hits].should == '3'
    stat_hash[1][:doubles].should == '4'
    stat_hash[1][:triples].should == '5'
    stat_hash[1][:home_runs].should == '6'
    stat_hash[1][:runs_batted_in].should == '7'
    stat_hash[1][:stolen_bases].should == '8'
    stat_hash[1][:caught_stealing].should == '9'
  end

end
