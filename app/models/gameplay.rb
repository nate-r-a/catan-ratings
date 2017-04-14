class Gameplay < ApplicationRecord
  belongs_to :game
  belongs_to :player
  # attr_accessor :date, :score, :before, :after, :date
  # after_initialize :init
  
  # def init
  #   self.before = self.player.gameplays.where("gameplays.game_id < ?", self.game.number) || 1000
  # end
  
  def calc_prov_win
    provk = 25
    puts "Provisional pre-.after rating: #{self.after}, gameplay id = #{self.id}"
    if self.score == 10
      puts "#{self.player.name} won this provisional game (##{self.game.number})"
      self.after += ((self.game.gameplays.count-1) * provk)
    else
      puts "#{self.player.name} lost this provisional game (##{self.game.number})"
      prop = self.score / (self.game.gameplays.sum(:score)-10)
      rc = (-2*provk) + (prop * (provk * self.game.gameplays.count-1))
      
      # rc should be negative
      self.after += rc
    end
  end
        
      
      
      
  def h2h(opp)
    beta =    -550
    regk =    25
    wl =      5
    oppprov = 1
    
    puts "Game #{self.game.number}: #{self.player.name} vs #{opp.player.name}"
    
    if opp.player.provisional?
      if self.score > opp.score
        self.after += (oppprov * self.game.player_count)
        self.save
        return
      elsif self.score < opp.score
        self.after -= (oppprov * self.game.player_count)
        self.save
        return
      end
    end
    
    exp_score = [((self.before + beta) / (opp.before + beta) * opp.score), 2].max
    score_prop = [(self.score / exp_score), (exp_score / self.score)].min - 1
    rc = score_prop * regk
    
    # Win/loss ------
    if self.score > opp.score
      self.after += wl
      opp.after  -= wl
    elsif self.score < opp.score
      self.after -= wl
      opp.after  += wl
    end
    
    # Score comparisons ------
    exp_score = [((self.before + beta) / (opp.before + beta) * opp.score), 2].max
    score_prop = [(self.score / exp_score), (exp_score / self.score)].min - 1
    rc = score_prop * regk
    
    if self.score > exp_score
      self.after  += rc
      opp.after   -= rc
    elsif self.score < exp_score
      self.after  -= rc
      opp.after   += rc 
    end
    
    self.save
    opp.save
  end
end
