class Athlete
  include Mongoid::Document

  field :athlete_id, type: String
  field :firstName, type: String
  field :lastName, type: String
  field :fullName, type: String
  field :age, type: Integer
  field :ageLabel, type: String
  embeds_one :team
  accepts_nested_attributes_for :team

  validates_presence_of :firstName
end
