class Stat < ActiveRecord::Base
  belongs_to :player

  scope :for_year, lambda { |year| where(:year => year) }

end
