require 'spec_helper'

describe Player do
  it 'accepts intialization params' do
    player = Player.new(player_id: 'compton01', birth_year: 1995, first_name: 'Keith', last_name: 'Compton')

    player.player_id.should == 'compton01'
    player.first_name.should == 'Keith'
    player.last_name.should == 'Compton'
    player.birth_year.should == 1995
  end
end