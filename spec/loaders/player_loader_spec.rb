require 'spec_helper'
require './lib/loaders/player_loader'

describe 'PlayerLoader' do

  it 'creates new players from valid data' do
    loader = PlayerLoader.new
    player_data = {player_id: 'test123', birth_year: '1956', first_name: 'Bob', last_name: 'Testington'}

    Player.should_receive(:destroy_all)
    Player.should_receive(:create).with(player_data)

    loader.load([player_data])
  end
end
