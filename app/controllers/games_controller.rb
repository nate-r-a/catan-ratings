class GamesController < ApplicationController
  def show
    @game = Game.find_by(number: params[:number])
  end
end
