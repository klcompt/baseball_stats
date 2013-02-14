require 'csv'

class PlayerParser

  def initialize(input_data)
    @input_data = input_data
  end

  # Ex. input contents:
  # playerID,birthYear,nameFirst,nameLast
  # aaronha01,1934,Hank,Aaron
  # aaronto01,1939,Tommie,Aaron
  def parse
    data = CSV.parse(@input_data)
    data.shift   # remove header row
    headers = [:player_id, :birth_year, :first_name, :last_name]
    data.map {|row| Hash[ *(headers.zip(row).flatten) ] }
  end

end
