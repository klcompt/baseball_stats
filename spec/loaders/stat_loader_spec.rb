require 'spec_helper'
require './lib/loaders/stat_loader'

describe 'StatLoader' do

  let(:stat_data) { { player_key: 'test123', year: '2011', team_id: 'NYA', game: '74',
      at_bats: '6', runs: '5', hits: '3', doubles: nil, triples: '1', home_runs: '0',
      runs_batted_in: '9', stolen_bases: '8', caught_stealing: '1' } }
  let(:player_stats) { [] }
  let(:player) { mock Player, :stats => player_stats, :save => true }
  let(:stat) { mock Stat }

  before(:each) do
    Stat.stub(:destroy_all)
    Player.stub(:find_by_player_key).and_return(player)
    Stat.stub(:new).and_return(stat)
  end

  it 'creates new stats from valid data' do

    Stat.should_receive(:destroy_all)
    Player.should_receive(:find_by_player_key).with(stat_data[:player_key])
    expected_params = stat_data.dup
    expected_params.delete(:player_key)
    expected_params[:doubles] = 0
    Stat.should_receive(:new).with(expected_params)
    player_stats.should_receive(:<<).with(stat)
    player.should_receive(:save)

    loader = StatLoader.new
    loader.load([stat_data])
  end

  it 'does not create a stat if a player does not exist' do
    Player.stub!(:find_by_player_key => nil)

    Stat.should_not_receive(:new)
    loader = StatLoader.new
    loader.load([stat_data])
  end

  it 'zeroes out count fields that are blank' do
    expected_stat_data = stat_data.dup
    expected_stat_data.delete(:player_key)
    StatLoader::COUNT_FIELDS.each do |key|
      expected_stat_data[key] = 0
    end
    StatLoader::COUNT_FIELDS.each do |key|
      stat_data[key] = nil
    end

    Stat.should_receive(:new).with(expected_stat_data)
    loader = StatLoader.new
    loader.load([stat_data])
  end

end
