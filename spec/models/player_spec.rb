require 'spec_helper'

describe 'Player' do
  it 'accepts intialization params' do
    p = Player.new(player_id: 'compton01', birth_year: 1995, first_name: 'Keith', last_name: 'Compton')
    p.player_id.should == 'compton01'
    p.first_name.should == 'Keith'
    p.last_name.should == 'Compton'
    p.birth_year.should == 1995
  end
end
