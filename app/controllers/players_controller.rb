class PlayersController < ApplicationController
  def show
    @player = Player.where("LOWER(name) = ?", params[:name].downcase).first
  end
end
