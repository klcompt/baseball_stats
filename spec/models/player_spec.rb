require 'spec_helper'

describe Player do

  it { should have_many(:stats) }

  it 'accepts intialization params' do
    player = Player.new(player_key: 'compton01', birth_year: 1995, first_name: 'Keith', last_name: 'Compton')

    player.player_key.should == 'compton01'
    player.first_name.should == 'Keith'
    player.last_name.should == 'Compton'
    player.birth_year.should == 1995
  end

  describe 'Player.most_improved_batting_average' do


    context 'database records exist' do
      let(:first_year) { 2009 }
      let(:second_year) { 2010 }

      let!(:player_only_first_year) do
        stats = [ build_stat( first_year, 'Mets', 34, 280, 19, 140, 6, 4, 3, 0, 0, 0 ) ]
        player = build_player('sandbob', 1975, 'Bob', 'Sanders', stats)
        player.save!
        player
      end

      let!(:player_both_years_high_avg_low_improvement) do
        stats = [ build_stat( first_year, 'Cards', 34, 280, 19, 200, 6, 4, 3, 0, 0, 0 ),
                  build_stat( second_year, 'Cards', 34, 270, 19, 200, 6, 4, 3, 0, 0, 0 ) ]

        player = build_player('evancar', 1975, 'Carl', 'Evans', stats)
        player.save!
        player
      end

      let!(:player_both_years_highest_improvement_few_at_bats) do
        stats = [ build_stat( first_year, 'whitesocks', 34, 80, 19, 3, 6, 4, 3, 0, 0, 0 ),
                  build_stat( second_year, 'whitesocks', 34, 270, 19, 250, 6, 4, 3, 0, 0, 0 ) ]

        player = build_player('hermanh', 1975, 'Hank', 'Herman', stats)
        player.save!
        player
      end

      let!(:player_both_years_many_teams_very_impoved) do
        stats = [ build_stat( first_year, 'Cards', 34, 280, 19, 100, 6, 4, 3, 0, 0, 0 ),
                  build_stat( first_year, 'NYA', 34, 380, 19, 100, 6, 4, 3, 0, 0, 0 ),
                  build_stat( second_year, 'Cards', 34, 570, 19, 400, 6, 4, 3, 0, 0, 0 ) ]

        player = build_player('sallyman', 1975, 'Mander', 'Sally', stats)
        player.save!
        player
      end

      it 'computes most improved batting average for given years with given min_at_bats' do

        player_data = Player.most_improved_batting_average(first_year, second_year, 200)

        player_data[:improvement].should be_within(0.0001).of(0.3987)
        player_data[:average].should be_within(0.001).of(0.702)
        player_data[:player].should == player_both_years_many_teams_very_impoved
      end
    end
  end


  describe 'Player.find_all_that_played_both_years' do
    let(:player1) { mock('Player1') }
    let(:player2) { mock('Player2') }
    let(:player3) { mock('Player3') }
    let(:players_2009) { [ player1, player2 ] }
    let(:players_2010) { [ player1, player3 ] }

    it 'should take the intersection of both resultsets' do
      Player.should_receive(:for_year).with(2009).and_return(players_2009)
      Player.should_receive(:for_year).with(2010).and_return(players_2010)

      Player.find_all_that_played_both_years(2009, 2010).should == [ player1 ]
    end
  end

  describe 'Player.triple_crown_winner' do
    let(:year) { 1997 }
    let(:min_at_bats) { 500 }
    let(:player_too_few_at_bats) { mock('PlayerTooFew', :has_min_at_bats? => false) }
    let(:player_meets_min) { mock('PlayerMeetsMin', :has_min_at_bats? => true) }


    before(:each) do
      Player.stub(:for_year).and_return( [ player_too_few_at_bats, player_meets_min ] )
      Player.stub(:players_with_highest_batting_avg).and_return([])
      Player.stub(:players_that_have_most_home_runs).and_return([])
      Player.stub(:players_that_have_most_rbis).and_return([])
    end

    it 'should get players for given year' do
      Player.should_receive(:for_year).with(year).and_return( [ player_too_few_at_bats, player_meets_min ] )

      Player.triple_crown_winner(year, min_at_bats)
    end

    it 'should filter for those that meet min_at_bats' do
      player_too_few_at_bats.should_receive(:has_min_at_bats?).with(year, min_at_bats)
      player_meets_min.should_receive(:has_min_at_bats?).with(year, min_at_bats)

      Player.triple_crown_winner(year, min_at_bats)
    end

    it 'should call method to get players with highest batting avg' do
      Player.should_receive(:players_with_highest_batting_avg).with([player_meets_min], year)

      Player.triple_crown_winner(year, min_at_bats)
    end

    it 'should call method to get players with most home runs' do
      Player.should_receive(:players_that_have_most_home_runs).with([player_meets_min], year)

      Player.triple_crown_winner(year, min_at_bats)
    end

    it 'should call method to get players with most rbis' do
      Player.should_receive(:players_that_have_most_rbis).with([player_meets_min], year)

      Player.triple_crown_winner(year, min_at_bats)
    end
  end


  private

  def build_player(key, birth, first_name, last_name, stats = nil)
    player = Player.new(player_key: key, birth_year: birth, first_name: first_name, last_name: last_name)
    player.stats = stats if stats
    player
  end

  def build_stat(year, team_id, game, at_bats, runs, hits, doubles, triples,
                 home_runs, runs_batted_in, stolen_bases, caught_stealing)

    Stat.new(year: year, team_id: team_id, game: game, at_bats: at_bats,
             runs: runs, hits: hits, doubles: doubles, triples: triples,
             home_runs: home_runs, runs_batted_in: runs_batted_in, 
             stolen_bases: stolen_bases, caught_stealing: caught_stealing)
  end

end
