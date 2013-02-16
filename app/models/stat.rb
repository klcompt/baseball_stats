class Stat < ActiveRecord::Base
  belongs_to :player

  scope :for_year, lambda { |year| where(:year => year) }
  scope :for_team, lambda { |team| where(:team_id => team) }
  scope :for_team_and_year, lambda { |team, year| for_team(team).for_year(year) }


  def slugging_percentage
    if at_bats > 0
      ((hits - doubles - triples - home_runs) + (2 * doubles) + (3 * triples) + (4 * home_runs)) / at_bats.to_f
    else
      0.0
    end
  end

end
