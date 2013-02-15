require 'spec_helper'
require './lib/parsers/player_parser'

describe 'PlayerParser' do

  it 'parses input correctly' do
    io = "playerID,birthYear,nameFirst,nameLast\naaronha01,1934,Hank,Aaron\nbaronto01,1939,Tommie,Baron\n"

    parser = PlayerParser.new(io)
    player_hash = parser.parse

    player_hash[0][:player_key].should == 'aaronha01'
    player_hash[0][:birth_year].should == '1934' 
    player_hash[0][:first_name].should == 'Hank'
    player_hash[0][:last_name].should == 'Aaron'

    player_hash[1][:player_key].should == 'baronto01'
    player_hash[1][:birth_year].should == '1939'
    player_hash[1][:first_name].should == 'Tommie'
    player_hash[1][:last_name].should == 'Baron'
  end

end
