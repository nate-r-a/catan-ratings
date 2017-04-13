class Game < ApplicationRecord
  has_many :gameplays
  
  def winner
    self.gameplays.where(score: 10).player.name
  end
  
  def player_count
    self.gameplays.count
  end
  
  # Recalculates ratings for ALL games
  def self.recalculate_ratings
    # These two bits reset everyone's ratings
    Gameplay.all.each do |gp|
      gp.before = nil
      gp.after = nil
    end
    
    Player.all.each do |p|
      p.gameplays.first.before = 1000
    end
    
    # TODO: Fill in add'l variables, also, the rest of the math
    $PROVK = 25
    
    
    
    Game.all.each do |game|
      game.gameplays.each do |gp|
        if gp.player.provisional?
          gp.calc_prov_win
          next
        end
        
        unless gp.position == game.player_count
          gp.game.gameplays.where("position > ?", gp.position).each do |opp|
            gp.h2h(opp)
          end
        end
        
        
        
      end
      
    end
  end
  
end
