class AthleteService
  attr_accessor :url

  def initialize
    @url = 'https://sports.core.api.espn.com/v2/sports/football/leagues/nfl/athletes'
  end

  def execute
    pages = 10
    team_properties = [:name, :location, :displayName, :color, :alternateColor]
    expand = [{
      name: :team,
      properties: team_properties
    }]
    properties = [:id, :firstName, :lastName, :fullName, :age]
    limit_per_page = 25
    athletes = fetch_athletes(pages, expand, properties, limit_per_page)
    create_athletes(athletes, true)
    set_athlete_ageLabels
  end

  private

  def fetch_athletes(pages, expand, properties, limit_per_page = 25)
    hydra = Typhoeus::Hydra.hydra
    athletes = Array.new
    pages.times do |page|
      fetch_url = url + "?page=#{page+1}&limit=#{limit_per_page}"
      athletes_page_req = Typhoeus::Request.new(fetch_url)
      athletes_page_req.on_complete do |athletes_response|
        if athletes_response.response_code == 200
          athletes_data = parse_data_as_hash(athletes_response.body)
          athletes_data[:items].each do |athlete_ref|
            athlete_doc = HashWithIndifferentAccess.new
            athlete_req = Typhoeus::Request.new(athlete_ref['$ref'])
            athlete_req.on_complete do |athlete_response|
              if athlete_response.response_code == 200
                athlete_data = parse_data_as_hash(athlete_response.body)
                athlete_doc[:athlete_id] = athlete_data[:id]
                properties.each do |property|
                  athlete_doc[property] = athlete_data[property] unless property == :id
                end
                expand.each do |field|
                  field = field.with_indifferent_access
                  field_doc = HashWithIndifferentAccess.new
                  field_ref = athlete_data[field[:name]]
                  field_data_req = Typhoeus::Request.new(field_ref['$ref'])
                  field_data_req.on_complete do |field_data_response|
                    if field_data_response.response_code == 200
                      field_data = parse_data_as_hash(field_data_response.body)
                      field[:properties].each do |property|
                        field_doc[property] = field_data[property]
                      end
                      athlete_doc[field[:name]] = field_doc
                    end
                  end
                  hydra.queue(field_data_req)
                end
              end
            end
            hydra.queue(athlete_req)
            athletes << athlete_doc
          end
        end
      end
      hydra.queue(athletes_page_req)
    end
    hydra.run
    athletes
  end

  def create_athletes(athletes, clear_collection = false)
    Athlete.destroy_all if clear_collection
    Athlete.create(athletes)
  end

  def set_athlete_ageLabels
    Athlete.all.each do |athlete|
      if athlete.age.present?
        athlete.ageLabel = athlete.age > Athlete.avg(:age) ? 'Senior' : 'Junior'
        athlete.save
      end
    end
  end

  def parse_data_as_hash(data)
    JSON.parse(data.to_s).with_indifferent_access
  end
end
