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
    puts "Provisional game for #{self.player.name}, gameplay id = #{self.id}"
    if self.score == 10
      puts "#{self.player.name} won this provisional game (##{self.game.number})"
      self.after += ((self.game.gameplays.count-1) * provk)
      self.save
    else
      puts "#{self.player.name} lost this provisional game (##{self.game.number})"
      puts "sum = #{self.game.gameplays.sum(:score)}"
      prop = self.score / (self.game.gameplays.sum(:score)-10)
      puts "prop: #{prop}"
      rc = (-2*provk) + (prop * (provk * (self.game.gameplays.count-1)))
      puts "rc = #{rc}"
      # rc should be negative
      self.after += rc
      self.save
    end
    puts self.after
  end
        
      
      
      
  def h2h(opp, opp_prov)
    beta =    -550
    regk =    25
    wl =      5
    oppprov = 1
    
    puts "Game #{self.game.number}: #{self.player.name} vs #{opp.player.name}"
    
    if opp_prov
      puts "#{opp.player.name} is provisional"
      if self.score > opp.score
        self.after += (oppprov * self.game.player_count)
        puts self.after
        self.save
        return
      elsif self.score < opp.score
        self.after -= (oppprov * self.game.player_count)
        puts self.after
        self.save
        return
      else # tie with provisional opp
        return
      end
    end
    puts "NOT PROVISONAL <<<<<<<<<<<<<<<<"
    exp_score = [((self.before + beta) / (opp.before + beta) * opp.score), 2].max
    puts "Exp score: #{exp_score}, "
    score_prop = [(self.score / exp_score), (exp_score / self.score)].min - 1
    print "Score prop: #{score_prop}"
    rc = score_prop * regk
    puts ", rc: #{rc}"
    
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
