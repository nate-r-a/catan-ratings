class Gameplay < ApplicationRecord
  belongs_to :game
  belongs_to :player
  # after_initialize :init
  
  # def init
  #   self.before = self.player.gameplays.where("gameplays.game_id < ?", self.game.number) || 1000
  # end
  
  def calc_prov_win
    provk =   25
    
    if self.score == 10
      puts "#{self.player.name} won this provisional game (#{self.game.number})"
      self.after = self.before + ((self.game.gameplays.count-1) * provk)
    else
      puts "#{self.player.name} lost this provisional game (#{self.game.number})"
      prop = self.score.to_f / (self.game.gameplays.sum(:score)-10)
      rc = (-2*provk) + (prop * (provk * self.game.gameplays.count-1))
      # rc should be negative
      self.after = self.before + rc
    end
  end
        
      
      
      
  def h2h(opp)
    beta =    -550
    regk =    25
    provk =   25
    wl =      5
    oppprov = 1
    
    exp_score = [((self.before + beta) / (opp.before + beta) * opp.score), 2].max
    score_prop = [(self.score / exp_score), (exp_score / self.score)].min - 1
    rc = score_prop * regk
    
    if self.score > opp.score
      self.after  = self.before + wl
      opp.after   = opp.before - wl
    elsif self.score < opp.score
      self.after  = self.before - wl
      opp.after   = opp.before + wl
    end
    
    if self.score > exp_score
      self.after  += rc
      opp.after   -= rc
    elsif self.score < exp_score
      self.after  -= rc
      opp.after   += rc 
    end
    
  end
    
    
    
    
  
end
