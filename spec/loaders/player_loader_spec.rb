require 'spec_helper'
require './lib/loaders/player_loader'

describe 'PlayerLoader' do

  it 'creates new players from valid data' do
    player_data = {player_key: 'test123', birth_year: '1956', first_name: 'Bob', last_name: 'Testington'}

    Player.should_receive(:delete_all)
    Player.should_receive(:create).with(player_data)

    loader = PlayerLoader.new
    loader.load([player_data])
  end
end
