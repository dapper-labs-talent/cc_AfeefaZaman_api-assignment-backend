class Team
  include Mongoid::Document

  field :name, type: String
  field :location, type: String
  field :displayName, type: String
  field :color, type: String
  field :alternateColor, type: String
end
