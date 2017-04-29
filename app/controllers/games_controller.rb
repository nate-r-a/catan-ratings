class GamesController < ApplicationController
  def show
    @game = Game.find_by(number: params[:number])
  end
  
  def search
    search_term = params[:number]
    if Game.exists?(number: search_term)
      redirect_to "/games/#{search_term}"
    else
      flash[:alert] = "That game doesn't exist!"
    end
  end
  
end
