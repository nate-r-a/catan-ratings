class PlayersController < ApplicationController
  def show
    @player = Player.find_by(name: params[:name].capitalize)
  end
end
