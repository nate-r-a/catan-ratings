class Gameplay < ApplicationRecord
  belongs_to :game
  belongs_to :player
  # after_initialize :init
  
  # def init
  #   self.before = self.player.gameplays.where("gameplays.game_id < ?", self.game.number) || 1000
  # end
  
  def win?
    beta =    -550
    regk =    25
    provk =   25
    wl =      5
    oppprov = 1
    
    if self.player.provisional?
      if self.score == 10
        puts "#{self.player.name} won this provisional game #{self.game.number}."
        self.after = self.before + ((self.game.gameplays.count-1) * provk)
        return true
      else
        puts "#{self.player.name} lost this provisional game #{self.game.number}."
        prop = self.score.to_f / (self.game.gameplays.sum(:score)-10)
        rc = (-2*provk) + (prop * (provk * self.game.gameplays.count-1))
        # rc should be negative
        self.after = self.before + rc
      end
      
    end
    
  end
        
      
      
      
  def h2h(opp)
    beta =    -550
    regk =    25
    provk =   25
    wl =      5
    oppprov = 1
    
    if self.provisional?
      if self.score == 10
        puts "#{self.name} won this provisional game."
        # self.
        
      end
      
    end
    
    
    
    
  end
end
