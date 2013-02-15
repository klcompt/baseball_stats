require 'spec_helper'
require './lib/loaders/stat_loader'

describe 'StatLoader' do

  it 'creates new stats from valid data' do
    loader = StatLoader.new
    stat_data = {player_id: 'test123', year: '2011', team_id: 'NYA', game: '74',
      at_bats: '6', runs: '5', hits: '3', doubles: nil, triples: '1', home_runs: '0',
      runs_batted_in: '9', stolen_bases: '8', caught_stealing: '1'}

    Stat.should_receive(:create).with(stat_data)

    loader.load([stat_data])
  end
end
