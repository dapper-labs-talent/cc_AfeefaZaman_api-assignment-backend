class AthletesController < ApplicationController
  def index
    AthleteService.new.execute unless Athlete.exists?
    render json: Athlete.all
  end
end
